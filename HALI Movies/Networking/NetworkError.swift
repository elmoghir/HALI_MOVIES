//
//  NetworkError.swift
//  Hali Cinema
//
//  Typed networking failures surfaced to ViewModels and UI error states.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case noInternet
    case timeout
    case cancelled
    case http(statusCode: Int)
    case decoding(String)
    case api(message: String)
    case missingAPIKey
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return String(localized: "Invalid request URL.")
        case .invalidResponse:
            return String(localized: "Unexpected server response.")
        case .noInternet:
            return String(localized: "No internet connection.")
        case .timeout:
            return String(localized: "The request timed out. Please try again.")
        case .cancelled:
            return String(localized: "Request cancelled.")
        case .http(let statusCode):
            switch statusCode {
            case 401:
                return String(localized: "Invalid API key. Check Secrets.xcconfig.")
            case 404:
                return String(localized: "Content not found.")
            case 429:
                return String(localized: "Too many requests. Please wait a moment.")
            default:
                return String(localized: "Server error (\(statusCode)).")
            }
        case .decoding(let detail):
            return String(localized: "Failed to read data: \(detail)")
        case .api(let message):
            return message
        case .missingAPIKey:
            return String(localized: "TMDb API key missing. Add it to Secrets.xcconfig.")
        case .unknown(let message):
            return message
        }
    }

    var isRetryable: Bool {
        switch self {
        case .noInternet, .timeout:
            return true
        case .http(let code):
            return code >= 500 || code == 429
        default:
            return false
        }
    }

    static func map(_ error: Error) -> NetworkError {
        if let network = error as? NetworkError {
            return network
        }
        if error is CancellationError {
            return .cancelled
        }
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorDataNotAllowed:
                return .noInternet
            case NSURLErrorTimedOut:
                return .timeout
            case NSURLErrorCancelled:
                return .cancelled
            default:
                return .unknown(nsError.localizedDescription)
            }
        }
        if error is DecodingError {
            return .decoding(error.localizedDescription)
        }
        return .unknown(error.localizedDescription)
    }
}

/// TMDb error payload when the API returns JSON with status_message.
struct TMDbAPIErrorResponse: Decodable {
    let statusCode: Int?
    let statusMessage: String?
    let success: Bool?
}
