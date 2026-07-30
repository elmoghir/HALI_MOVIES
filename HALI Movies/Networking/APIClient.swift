//
//  APIClient.swift
//  Hali Cinema
//
//  Generic async networking layer over URLSession.
//  Supports GET + Decodable, typed errors, timeout, and cancellation.
//

import Foundation

protocol APIClientProtocol: Sendable {
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T
}

/// Production TMDb client. Inject a mock conforming to `APIClientProtocol` in tests.
final class APIClient: APIClientProtocol, Sendable {
    private let session: URLSession
    private let baseURL: URL
    private let apiKey: String
    private let decoder: JSONDecoder

    init(
        apiKey: String = AppConfiguration.tmdbAPIKey,
        baseURL: URL = Constants.tmdbBaseURL,
        session: URLSession? = nil
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        if let session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = Constants.requestTimeout
            configuration.timeoutIntervalForResource = Constants.requestTimeout * 2
            configuration.waitsForConnectivity = true
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            self.session = URLSession(configuration: configuration)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        guard !apiKey.isEmpty else {
            throw NetworkError.missingAPIKey
        }

        var url = try endpoint.makeURL(baseURL: baseURL)
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var items = components.queryItems ?? []
            items.append(URLQueryItem(name: "api_key", value: apiKey))
            components.queryItems = items
            guard let keyed = components.url else { throw NetworkError.invalidURL }
            url = keyed
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(http.statusCode) else {
                if let apiError = try? decoder.decode(TMDbAPIErrorResponse.self, from: data),
                   let message = apiError.statusMessage {
                    throw NetworkError.api(message: message)
                }
                throw NetworkError.http(statusCode: http.statusCode)
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decoding(String(describing: error))
            }
        } catch {
            throw NetworkError.map(error)
        }
    }
}
