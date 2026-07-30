//
//  AppEnvironment.swift
//  Hali Cinema
//
//  Dependency injection container. Constructed once at launch and injected
//  into the SwiftUI environment for ViewModels and views.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
@MainActor
final class AppEnvironment {
    let apiClient: APIClientProtocol
    let movieRepository: MovieRepositoryProtocol
    let searchRepository: SearchRepositoryProtocol
    let tvRepository: TVRepositoryProtocol
    let configurationRepository: ConfigurationRepositoryProtocol
    let imageURLBuilder: ImageURLBuilder
    let networkMonitor: NetworkMonitor
    let searchHistory: SearchHistoryStore
    let modelContainer: ModelContainer

    private(set) var favoritesRepository: FavoritesRepository

    init(
        apiClient: APIClientProtocol? = nil,
        modelContainer: ModelContainer? = nil
    ) {
        let client = apiClient ?? APIClient()
        self.apiClient = client
        self.movieRepository = MovieRepository(client: client)
        self.searchRepository = SearchRepository(client: client)
        self.tvRepository = TVRepository(client: client)
        self.configurationRepository = ConfigurationRepository(client: client)
        self.imageURLBuilder = ImageURLBuilder()
        self.networkMonitor = NetworkMonitor()
        self.searchHistory = SearchHistoryStore()

        let container: ModelContainer
        if let modelContainer {
            container = modelContainer
        } else {
            let schema = Schema([FavoriteMovie.self])
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            do {
                container = try ModelContainer(for: schema, configurations: [configuration])
            } catch {
                fatalError("SwiftData container failed: \(error)")
            }
        }
        self.modelContainer = container
        self.favoritesRepository = FavoritesRepository(modelContext: container.mainContext)
    }

    /// Loads TMDb image configuration once at launch.
    func bootstrap() async {
        do {
            let config = try await configurationRepository.fetch()
            imageURLBuilder.update(with: config)
        } catch {
            // Defaults in ImageURLBuilder remain valid.
        }
    }

    /// In-memory environment for SwiftUI previews and unit tests.
    static var preview: AppEnvironment {
        let schema = Schema([FavoriteMovie.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        return AppEnvironment(apiClient: APIClient(apiKey: "preview"), modelContainer: container)
    }
}

private struct AppEnvironmentKey: EnvironmentKey {
    @MainActor static var defaultValue: AppEnvironment { AppEnvironment.preview }
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
