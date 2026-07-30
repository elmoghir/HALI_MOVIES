//
//  Genre.swift
//  Hali Cinema
//

import Foundation

struct Genre: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let name: String
}

struct GenreListResponse: Decodable, Sendable {
    let genres: [Genre]
}
