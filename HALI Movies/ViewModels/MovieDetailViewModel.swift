//
//  MovieDetailViewModel.swift
//  Hali Cinema
//

import Foundation

@Observable
@MainActor
final class MovieDetailViewModel {
    private let movieRepository: MovieRepositoryProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol
    let movieID: Int

    var detail: MovieDetail?
    var isFavorite = false
    var state: LoadState = .idle
    var errorMessage: String?

    init(
        movieID: Int,
        movieRepository: MovieRepositoryProtocol,
        favoritesRepository: FavoritesRepositoryProtocol
    ) {
        self.movieID = movieID
        self.movieRepository = movieRepository
        self.favoritesRepository = favoritesRepository
    }

    func load() async {
        state = .loading
        errorMessage = nil
        do {
            async let detailTask = movieRepository.detail(id: movieID)
            let favorite = try favoritesRepository.isFavorite(id: movieID)
            detail = try await detailTask
            isFavorite = favorite
            state = detail == nil ? .empty : .loaded
        } catch {
            let mapped = NetworkError.map(error)
            if mapped == .cancelled { return }
            errorMessage = mapped.localizedDescription
            state = .failed(mapped.localizedDescription)
        }
    }

    func toggleFavorite() {
        guard let movie = detail?.asMovie else { return }
        do {
            isFavorite = try favoritesRepository.toggle(movie)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
