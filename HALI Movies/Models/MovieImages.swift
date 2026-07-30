//
//  MovieImages.swift
//  Hali Cinema
//

import Foundation

struct MovieImages: Codable, Sendable {
    let backdrops: [MovieImage]
    let posters: [MovieImage]
    let logos: [MovieImage]?
}

struct MovieImage: Identifiable, Codable, Hashable, Sendable {
    var id: String { filePath ?? UUID().uuidString }
    let aspectRatio: Double?
    let filePath: String?
    let height: Int?
    let width: Int?
    let voteAverage: Double?
    let voteCount: Int?
}
