//
//  FavoritesViewModel.swift
//  Hali Cinema
//

import Foundation

@Observable
@MainActor
final class FavoritesViewModel {
    private let favoritesRepository: FavoritesRepositoryProtocol

    var favorites: [FavoriteMovie] = []
    var errorMessage: String?

    init(favoritesRepository: FavoritesRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
    }

    func load() {
        do {
            favorites = try favoritesRepository.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func remove(id: Int) {
        do {
            try favoritesRepository.remove(id: id)
            favorites.removeAll { $0.tmdbId == id }
            HapticFeedback.light()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
