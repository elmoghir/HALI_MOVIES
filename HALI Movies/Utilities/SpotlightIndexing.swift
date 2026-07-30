//
//  SpotlightIndexing.swift
//  Hali Cinema
//
//  Preparation hooks for CoreSpotlight indexing (not fully enabled yet).
//  Call `SpotlightIndexer.prepare(movie:)` when shipping Spotlight Search.
//

import CoreSpotlight
import Foundation
import UniformTypeIdentifiers

enum SpotlightIndexer {
    /// Builds a searchable item for a movie. Wire into favorites / detail open later.
    static func searchableItem(for movie: Movie) -> CSSearchableItem {
        let attributes = CSSearchableItemAttributeSet(contentType: .content)
        attributes.title = movie.displayTitle
        attributes.contentDescription = movie.overview
        attributes.keywords = [movie.displayTitle, "movie", "Hali Cinema"]
        return CSSearchableItem(
            uniqueIdentifier: "movie.\(movie.id)",
            domainIdentifier: "com.elmoghir.HALI-Movies.movies",
            attributeSet: attributes
        )
    }

    static func prepare(movie: Movie) {
        // Intentionally no-op until Spotlight entitlement & App Store readiness.
        _ = searchableItem(for: movie)
    }
}
