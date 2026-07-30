//
//  Video.swift
//  Hali Cinema
//

import Foundation

struct VideoListResponse: Decodable, Sendable {
    let results: [Video]
}

struct Video: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let key: String?
    let name: String?
    let site: String?
    let type: String?
    let official: Bool?
    let publishedAt: String?

    var youtubeURL: URL? {
        guard let key, site?.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }

    var youtubeEmbedURL: URL? {
        guard let key, site?.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/embed/\(key)")
    }

    var isTrailer: Bool {
        type?.lowercased() == "trailer"
    }
}

extension Array where Element == Video {
    var bestTrailer: Video? {
        let youtube = filter { $0.site?.lowercased() == "youtube" }
        return youtube.first(where: { $0.isTrailer && ($0.official ?? false) })
            ?? youtube.first(where: \.isTrailer)
            ?? youtube.first
    }
}
