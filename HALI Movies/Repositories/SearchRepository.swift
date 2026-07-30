//
//  SearchRepository.swift
//  Hali Cinema
//

import Foundation

protocol SearchRepositoryProtocol: Sendable {
    func searchMovies(query: String, page: Int) async throws -> PagedResponse<Movie>
}

final class SearchRepository: SearchRepositoryProtocol, Sendable {
    private let client: APIClientProtocol

    init(client: APIClientProtocol) {
        self.client = client
    }

    func searchMovies(query: String, page: Int) async throws -> PagedResponse<Movie> {
        try await client.request(TMDbEndpoint.searchMovies(query: query, page: page))
    }
}
