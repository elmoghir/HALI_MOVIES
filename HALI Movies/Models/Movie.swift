//
//  Movie.swift
//  Hali Cinema
//

import Foundation

struct Movie: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let title: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?
    let adult: Bool?
    let genreIds: [Int]?
    let originalLanguage: String?
    let video: Bool?

    /// Display title with a safe fallback.
    var displayTitle: String {
        title ?? originalTitle ?? String(localized: "Untitled")
    }

    var formattedReleaseYear: String? {
        guard let releaseDate, releaseDate.count >= 4 else { return nil }
        return String(releaseDate.prefix(4))
    }

    var tmdbURL: URL? {
        URL(string: "\(Constants.tmdbWebsiteBase)/movie/\(id)")
    }
}

extension Movie {
    static let preview = Movie(
        id: 550,
        title: "Fight Club",
        originalTitle: "Fight Club",
        overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
        posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
        backdropPath: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
        releaseDate: "1999-10-15",
        voteAverage: 8.4,
        voteCount: 28000,
        popularity: 60,
        adult: false,
        genreIds: [18],
        originalLanguage: "en",
        video: false
    )

    static let previews: [Movie] = [
        .preview,
        Movie(
            id: 278,
            title: "The Shawshank Redemption",
            originalTitle: "The Shawshank Redemption",
            overview: "Framed in the 1940s for two murders he didn't commit, upstanding banker Andy Dufresne begins a new life at Shawshank.",
            posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
            backdropPath: "/zfbjgQE1uSd9wiPTX4VzsLi0rGG.jpg",
            releaseDate: "1994-09-23",
            voteAverage: 8.7,
            voteCount: 26000,
            popularity: 90,
            adult: false,
            genreIds: [18, 80],
            originalLanguage: "en",
            video: false
        )
    ]
}
