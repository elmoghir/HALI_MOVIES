//
//  AppConfiguration.swift
//  Hali Cinema
//
//  Reads build-time secrets from Info.plist (injected via Config.xcconfig).
//

import Foundation

enum AppConfiguration {
    /// TMDb v3 API key from Info.plist / xcconfig.
    static var tmdbAPIKey: String {
        let candidates: [String?] = [
            Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKey.apiKey) as? String,
            Bundle.main.infoDictionary?[Constants.InfoPlistKey.apiKey] as? String,
            ProcessInfo.processInfo.environment["TMDB_API_KEY"]
        ]

        for candidate in candidates {
            guard let key = candidate?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !key.isEmpty,
                  key != "YOUR_TMDB_API_KEY_HERE",
                  !key.contains("$(") else { continue }
            return key
        }
        return ""
    }

    static var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    static var displayName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? "Hali Cinema"
    }
}
