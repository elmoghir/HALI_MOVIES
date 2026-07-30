//
//  FavoriteMovie.swift
//  Hali Cinema
//
//  SwiftData model for offline favorites persistence.
//

import Foundation
import SwiftData

@Model
final class FavoriteMovie {
    @Attribute(.unique) var tmdbId: Int
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double
    var releaseDate: String?
    var overview: String?
    var addedAt: Date

    init(
        tmdbId: Int,
        title: String,
        posterPath: String? = nil,
        backdropPath: String? = nil,
        voteAverage: Double = 0,
        releaseDate: String? = nil,
        overview: String? = nil,
        addedAt: Date = .now
    ) {
        self.tmdbId = tmdbId
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.overview = overview
        self.addedAt = addedAt
    }

    convenience init(movie: Movie) {
        self.init(
            tmdbId: movie.id,
            title: movie.displayTitle,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            voteAverage: movie.voteAverage ?? 0,
            releaseDate: movie.releaseDate,
            overview: movie.overview
        )
    }

    var asMovie: Movie {
        Movie(
            id: tmdbId,
            title: title,
            originalTitle: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            voteCount: nil,
            popularity: nil,
            adult: false,
            genreIds: nil,
            originalLanguage: nil,
            video: false
        )
    }
}
