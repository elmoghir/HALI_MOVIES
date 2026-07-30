//
//  MovieDetail.swift
//  Hali Cinema
//

import Foundation

struct MovieDetail: Identifiable, Decodable, Sendable {
    let id: Int
    let title: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double?
    let voteCount: Int?
    let status: String?
    let tagline: String?
    let budget: Int?
    let revenue: Int?
    let homepage: String?
    let originalLanguage: String?
    let popularity: Double?
    let adult: Bool?
    let genres: [Genre]?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let spokenLanguages: [SpokenLanguage]?
    let belongsToCollection: MovieCollection?
    let credits: Credits?
    let videos: VideoListResponse?
    let images: MovieImages?
    let recommendations: PagedResponse<Movie>?
    let similar: PagedResponse<Movie>?
    let reviews: PagedResponse<Review>?

    var displayTitle: String {
        title ?? originalTitle ?? String(localized: "Untitled")
    }

    var formattedRuntime: String? {
        guard let runtime, runtime > 0 else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    var formattedBudget: String? {
        Self.formatCurrency(budget)
    }

    var formattedRevenue: String? {
        Self.formatCurrency(revenue)
    }

    var homepageURL: URL? {
        guard let homepage, !homepage.isEmpty else { return nil }
        return URL(string: homepage)
    }

    var asMovie: Movie {
        Movie(
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            voteCount: voteCount,
            popularity: popularity,
            adult: adult,
            genreIds: genres?.map(\.id),
            originalLanguage: originalLanguage,
            video: false
        )
    }

    private static func formatCurrency(_ value: Int?) -> String? {
        guard let value, value > 0 else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value))
    }
}

struct ProductionCompany: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let name: String?
    let logoPath: String?
    let originCountry: String?
}

struct ProductionCountry: Codable, Hashable, Sendable {
    let iso31661: String?
    let name: String?
}

struct SpokenLanguage: Codable, Hashable, Sendable {
    let englishName: String?
    let iso6391: String?
    let name: String?
}

extension MovieDetail {
    static let preview = MovieDetail(
        id: 550,
        title: "Fight Club",
        originalTitle: "Fight Club",
        overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
        posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
        backdropPath: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
        releaseDate: "1999-10-15",
        runtime: 139,
        voteAverage: 8.4,
        voteCount: 28000,
        status: "Released",
        tagline: "Mischief. Mayhem. Soap.",
        budget: 63_000_000,
        revenue: 100_853_753,
        homepage: "https://www.foxmovies.com/movies/fight-club",
        originalLanguage: "en",
        popularity: 60,
        adult: false,
        genres: [Genre(id: 18, name: "Drama")],
        productionCompanies: [ProductionCompany(id: 508, name: "Regency Enterprises", logoPath: nil, originCountry: "US")],
        productionCountries: [ProductionCountry(iso31661: "US", name: "United States of America")],
        spokenLanguages: [SpokenLanguage(englishName: "English", iso6391: "en", name: "English")],
        belongsToCollection: nil,
        credits: Credits(cast: [.preview], crew: [CrewMember(id: 7467, name: "David Fincher", job: "Director", department: "Directing", profilePath: nil)]),
        videos: nil,
        images: nil,
        recommendations: nil,
        similar: nil,
        reviews: nil
    )
}
