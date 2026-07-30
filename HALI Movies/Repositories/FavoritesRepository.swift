//
//  FavoritesRepository.swift
//  Hali Cinema
//
//  SwiftData-backed favorites. Works fully offline.
//

import Foundation
import SwiftData

@MainActor
protocol FavoritesRepositoryProtocol {
    func fetchAll() throws -> [FavoriteMovie]
    func isFavorite(id: Int) throws -> Bool
    func add(_ movie: Movie) throws
    func remove(id: Int) throws
    func toggle(_ movie: Movie) throws -> Bool
}

@MainActor
final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [FavoriteMovie] {
        let descriptor = FetchDescriptor<FavoriteMovie>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func isFavorite(id: Int) throws -> Bool {
        var descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate { $0.tmdbId == id }
        )
        descriptor.fetchLimit = 1
        return try !modelContext.fetch(descriptor).isEmpty
    }

    func add(_ movie: Movie) throws {
        guard try !isFavorite(id: movie.id) else { return }
        modelContext.insert(FavoriteMovie(movie: movie))
        try modelContext.save()
    }

    func remove(id: Int) throws {
        let descriptor = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate { $0.tmdbId == id }
        )
        let matches = try modelContext.fetch(descriptor)
        for item in matches {
            modelContext.delete(item)
        }
        try modelContext.save()
    }

    func toggle(_ movie: Movie) throws -> Bool {
        if try isFavorite(id: movie.id) {
            try remove(id: movie.id)
            return false
        } else {
            try add(movie)
            return true
        }
    }
}
