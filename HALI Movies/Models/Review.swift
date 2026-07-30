//
//  Review.swift
//  Hali Cinema
//

import Foundation

struct Review: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let author: String?
    let content: String?
    let createdAt: String?
    let url: String?
    let authorDetails: AuthorDetails?

    struct AuthorDetails: Codable, Hashable, Sendable {
        let name: String?
        let username: String?
        let avatarPath: String?
        let rating: Double?
    }
}
