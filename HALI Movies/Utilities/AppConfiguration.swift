//
//  AppConfiguration.swift
//  Hali Cinema
//
//  Reads build-time secrets from Info.plist (injected via Config.xcconfig).
//

import Foundation

enum AppConfiguration {
    /// TMDb v3 API key from InfopList / xcconfig. Replace Secrets.xcconfig before shipping.
    static var tmdbAPIKey: String {
        if let key = Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKey.apiKey) as? String,
           !key.isEmpty,
           key != "YOUR_TMDB_API_KEY_HERE" {
            return key
        }
        // Development fallback — paste your key in Secrets.xcconfig for production builds.
        return ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? ""
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
