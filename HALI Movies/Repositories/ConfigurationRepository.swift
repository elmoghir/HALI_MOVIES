//
//  ConfigurationRepository.swift
//  Hali Cinema
//

import Foundation

protocol ConfigurationRepositoryProtocol: Sendable {
    func fetch() async throws -> TMDbConfiguration
}

final class ConfigurationRepository: ConfigurationRepositoryProtocol, Sendable {
    private let client: APIClientProtocol

    init(client: APIClientProtocol) {
        self.client = client
    }

    func fetch() async throws -> TMDbConfiguration {
        try await client.request(TMDbEndpoint.configuration)
    }
}
