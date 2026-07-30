//
//  ImageURLBuilder.swift
//  Hali Cinema
//
//  Builds TMDb image URLs from configuration (with sensible defaults).
//

import Foundation

enum ImageKind {
    case poster(large: Bool)
    case backdrop(large: Bool)
    case profile
    case original

    var sizePath: String {
        switch self {
        case .poster(let large):
            return large ? "w500" : "w342"
        case .backdrop(let large):
            return large ? "w1280" : "w780"
        case .profile:
            return "w185"
        case .original:
            return "original"
        }
    }
}

@Observable
@MainActor
final class ImageURLBuilder {
    private(set) var secureBaseURL: URL = Constants.tmdbImageBaseURL

    func update(with configuration: TMDbConfiguration) {
        if let base = configuration.images?.secureBaseUrl,
           let url = URL(string: base) {
            secureBaseURL = url
        }
    }

    func url(path: String?, kind: ImageKind) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        let cleaned = path.hasPrefix("/") ? path : "/\(path)"
        let base = secureBaseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return URL(string: "\(base)/\(kind.sizePath)\(cleaned)")
    }

    func url(path: String?, size: String) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        let cleaned = path.hasPrefix("/") ? path : "/\(path)"
        let base = secureBaseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return URL(string: "\(base)/\(size)\(cleaned)")
    }

    func posterURL(_ path: String?, large: Bool = false) -> URL? {
        url(path: path, kind: .poster(large: large))
    }

    func backdropURL(_ path: String?, large: Bool = true) -> URL? {
        url(path: path, kind: .backdrop(large: large))
    }

    func profileURL(_ path: String?) -> URL? {
        url(path: path, kind: .profile)
    }
}
