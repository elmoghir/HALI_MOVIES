//
//  Collection.swift
//  Hali Cinema
//

import Foundation

struct MovieCollection: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let name: String?
    let posterPath: String?
    let backdropPath: String?
}
