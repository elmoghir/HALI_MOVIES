//
//  AdsBootstrap.swift
//  Hali Cinema
//
//  Starts the Google Mobile Ads SDK without App Tracking Transparency.
//  Ads still load; they simply won't use the IDFA for cross-app tracking.
//

import GoogleMobileAds

enum AdsBootstrap {
    private static var didStart = false

    @MainActor
    static func start() async {
        guard !didStart else { return }
        didStart = true

        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            GADMobileAds.sharedInstance().start { _ in
                continuation.resume()
            }
        }
    }
}
