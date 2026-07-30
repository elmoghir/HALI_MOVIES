//
//  TMDbConfiguration.swift
//  Hali Cinema
//

import Foundation

struct TMDbConfiguration: Codable, Sendable {
    let images: ImageConfiguration?
    let changeKeys: [String]?
}

struct ImageConfiguration: Codable, Sendable {
    let baseUrl: String?
    let secureBaseUrl: String?
    let backdropSizes: [String]?
    let logoSizes: [String]?
    let posterSizes: [String]?
    let profileSizes: [String]?
    let stillSizes: [String]?
}
