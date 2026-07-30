//
//  WidgetSharedModels.swift
//  Hali Cinema
//
//  Shared value types prepared for a future WidgetKit extension target.
//  Keep this file free of UI so it can move into an App Group / shared framework.
//

import Foundation

struct WidgetMovieSnapshot: Codable, Sendable, Identifiable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double?

    init(movie: Movie) {
        id = movie.id
        title = movie.displayTitle
        posterPath = movie.posterPath
        voteAverage = movie.voteAverage
    }
}

enum WidgetDataBridge {
    static let suiteName = "group.com.elmoghir.HALI-Movies"
    static let trendingKey = "widget.trending.snapshot"

    /// Persist trending snapshots for widgets once an App Group is configured.
    static func saveTrending(_ movies: [Movie]) {
        let snapshots = movies.prefix(5).map(WidgetMovieSnapshot.init)
        guard let data = try? JSONEncoder().encode(Array(snapshots)) else { return }
        UserDefaults(suiteName: suiteName)?.set(data, forKey: trendingKey)
            ?? UserDefaults.standard.set(data, forKey: trendingKey)
    }
}
