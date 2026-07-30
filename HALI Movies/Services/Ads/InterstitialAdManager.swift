//
//  InterstitialAdManager.swift
//  Hali Cinema
//
//  Preloads interstitials and shows them when returning from movie detail,
//  with frequency capping (every N dismissals + minimum interval).
//

import GoogleMobileAds
import UIKit

@Observable
@MainActor
final class InterstitialAdManager: NSObject {
    private var interstitial: GADInterstitialAd?
    private var isLoading = false
    private var dismissCount = 0
    private var lastShownAt: Date?

    func preload() {
        guard interstitial == nil, !isLoading else { return }
        isLoading = true
        GADInterstitialAd.load(
            withAdUnitID: AdConfig.interstitialAdUnitID,
            request: GADRequest()
        ) { [weak self] ad, error in
            Task { @MainActor in
                guard let self else { return }
                self.isLoading = false
                if let error {
                    #if DEBUG
                    print("Interstitial load failed: \(error.localizedDescription)")
                    #endif
                    return
                }
                self.interstitial = ad
                self.interstitial?.fullScreenContentDelegate = self
            }
        }
    }

    /// Call when the user leaves a movie detail screen.
    func handleMovieDetailDismissed() {
        dismissCount += 1
        guard shouldShow() else {
            preload()
            return
        }
        showIfReady()
    }

    private func shouldShow() -> Bool {
        guard dismissCount % AdConfig.interstitialEveryNthDismiss == 0 else { return false }
        if let lastShownAt,
           Date().timeIntervalSince(lastShownAt) < AdConfig.interstitialMinimumInterval {
            return false
        }
        return interstitial != nil
    }

    private func showIfReady() {
        guard let interstitial,
              let root = BannerAdView.topViewController() else {
            preload()
            return
        }
        lastShownAt = Date()
        interstitial.present(fromRootViewController: root)
        self.interstitial = nil
    }
}

extension InterstitialAdManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        preload()
    }

    func ad(
        _ ad: any GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        interstitial = nil
        preload()
    }
}
