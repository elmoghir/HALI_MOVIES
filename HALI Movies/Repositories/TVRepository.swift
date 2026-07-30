//
//  TVRepository.swift
//  Hali Cinema
//

import Foundation

protocol TVRepositoryProtocol: Sendable {
    func popular(page: Int) async throws -> PagedResponse<TVShow>
}

final class TVRepository: TVRepositoryProtocol, Sendable {
    private let client: APIClientProtocol

    init(client: APIClientProtocol) {
        self.client = client
    }

    func popular(page: Int) async throws -> PagedResponse<TVShow> {
        try await client.request(TMDbEndpoint.popularTV(page: page))
    }
}
