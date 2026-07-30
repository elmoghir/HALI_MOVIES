//
//  AdConfig.swift
//  Hali Cinema
//
//  AdMob unit IDs from Info.plist / Secrets.xcconfig, with Google test ID fallbacks.
//

import Foundation

enum AdConfig {
    /// Google sample App ID — replace via Secrets.xcconfig for production.
    private static let testAppID = "ca-app-pub-3940256099942544~1458002511"
    private static let testBannerID = "ca-app-pub-3940256099942544/2934735716"
    private static let testInterstitialID = "ca-app-pub-3940256099942544/4411468910"
    private static let testAppOpenID = "ca-app-pub-3940256099942544/5575463023"

    static var appID: String {
        resolved("ADMOB_APP_ID", fallback: testAppID)
    }

    static var bannerAdUnitID: String {
        resolved("ADMOB_BANNER_ID", fallback: testBannerID)
    }

    static var interstitialAdUnitID: String {
        resolved("ADMOB_INTERSTITIAL_ID", fallback: testInterstitialID)
    }

    static var appOpenAdUnitID: String {
        resolved("ADMOB_APP_OPEN_ID", fallback: testAppOpenID)
    }

    /// Show interstitial every N-th return from movie detail.
    static let interstitialEveryNthDismiss = 2
    /// Minimum seconds between interstitial presentations.
    static let interstitialMinimumInterval: TimeInterval = 60
    /// App Open ads expire after ~4 hours; also used as warm-start threshold.
    static let appOpenFreshnessInterval: TimeInterval = 4 * 60 * 60

    private static func resolved(_ infoKey: String, fallback: String) -> String {
        if let value = Bundle.main.object(forInfoDictionaryKey: infoKey) as? String {
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty, !trimmed.contains("$("), !trimmed.contains("YOUR_") {
                return trimmed
            }
        }
        if let env = ProcessInfo.processInfo.environment[infoKey], !env.isEmpty {
            return env
        }
        return fallback
    }
}
