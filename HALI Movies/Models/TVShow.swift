//
//  TVShow.swift
//  Hali Cinema
//

import Foundation

struct TVShow: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let name: String?
    let originalName: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?
    let genreIds: [Int]?
    let originalLanguage: String?

    var displayTitle: String {
        name ?? originalName ?? String(localized: "Untitled")
    }

    var formattedYear: String? {
        guard let firstAirDate, firstAirDate.count >= 4 else { return nil }
        return String(firstAirDate.prefix(4))
    }

    /// Bridges TV rows into movie-card UI without duplicating card components.
    func asMovieProxy() -> Movie {
        Movie(
            id: id,
            title: displayTitle,
            originalTitle: originalName,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: firstAirDate,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            adult: false,
            genreIds: genreIds,
            originalLanguage: originalLanguage,
            video: false
        )
    }
}

extension TVShow {
    static let preview = TVShow(
        id: 1396,
        name: "Breaking Bad",
        originalName: "Breaking Bad",
        overview: "A chemistry teacher diagnosed with cancer teams with a former student to cook and sell meth.",
        posterPath: "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg",
        backdropPath: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg",
        firstAirDate: "2008-01-20",
        voteAverage: 8.9,
        voteCount: 13000,
        popularity: 200,
        genreIds: [18],
        originalLanguage: "en"
    )
}
