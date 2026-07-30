//
//  Constants.swift
//  Hali Cinema
//

import Foundation

enum Constants {
    static let tmdbBaseURL = URL(string: "https://api.themoviedb.org/3")!
    static let tmdbImageBaseURL = URL(string: "https://image.tmdb.org/t/p")!
    static let tmdbWebsiteBase = "https://www.themoviedb.org"
    static let requestTimeout: TimeInterval = 30
    static let searchDebounceNanoseconds: UInt64 = 300_000_000
    static let maxSearchHistory = 12

    /// Popular search seeds shown when the query field is empty.
    static let popularSearches = [
        "Inception",
        "The Dark Knight",
        "Interstellar",
        "Dune",
        "Oppenheimer",
        "Parasite",
        "Spirited Away",
        "The Godfather"
    ]

    enum InfoPlistKey {
        static let apiKey = "TMDBAPIKey"
    }
}
