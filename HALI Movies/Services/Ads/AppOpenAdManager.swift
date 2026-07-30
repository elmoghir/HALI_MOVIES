//
//  AppOpenAdManager.swift
//  Hali Cinema
//
//  Shows an App Open ad on cold start and after returning from background.
//  Waits until the ad is loaded before presenting (fixes silent no-op on launch).
//

import GoogleMobileAds
import SwiftUI
import UIKit

@Observable
@MainActor
final class AppOpenAdManager: NSObject {
    private var appOpenAd: GADAppOpenAd?
    private var isLoading = false
    private var isShowing = false
    private var loadTime: Date?
    private var wasInBackground = false
    /// When true, present as soon as a fresh ad finishes loading.
    private var pendingShow = false

    func load() {
        guard appOpenAd == nil, !isLoading else { return }
        isLoading = true
        #if DEBUG
        print("App Open: loading unit \(AdConfig.appOpenAdUnitID)")
        #endif
        GADAppOpenAd.load(
            withAdUnitID: AdConfig.appOpenAdUnitID,
            request: GADRequest()
        ) { [weak self] ad, error in
            Task { @MainActor in
                guard let self else { return }
                self.isLoading = false
                if let error {
                    #if DEBUG
                    print("App Open load failed: \(error.localizedDescription)")
                    #endif
                    // Retry once after a short delay if we still need to show.
                    if self.pendingShow {
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                        if self.pendingShow, self.appOpenAd == nil {
                            self.load()
                        }
                    }
                    return
                }
                self.appOpenAd = ad
                self.appOpenAd?.fullScreenContentDelegate = self
                self.loadTime = Date()
                #if DEBUG
                print("App Open: loaded successfully")
                #endif
                if self.pendingShow {
                    self.presentIfPossible()
                }
            }
        }
    }

    func handleScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .background:
            wasInBackground = true
        case .active:
            if wasInBackground {
                wasInBackground = false
                requestShow()
            }
        default:
            break
        }
    }

    /// Cold start: keep trying until the ad is ready (or give up after ~15s).
    func showOnColdStart() {
        pendingShow = true
        // Let the first frame + root VC appear, then request show.
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            requestShow()

            // Safety timeout so we don't block forever if fill fails.
            try? await Task.sleep(nanoseconds: 15_000_000_000)
            if pendingShow, !isShowing {
                pendingShow = false
                #if DEBUG
                print("App Open: gave up waiting for cold-start fill")
                #endif
            }
        }
    }

    private func requestShow() {
        pendingShow = true
        if isAdAvailable {
            presentIfPossible()
        } else {
            load()
        }
    }

    private var isAdAvailable: Bool {
        guard let loadTime, appOpenAd != nil else { return false }
        return Date().timeIntervalSince(loadTime) < AdConfig.appOpenFreshnessInterval
    }

    private func presentIfPossible() {
        guard !isShowing else { return }
        guard isAdAvailable, let appOpenAd else {
            load()
            return
        }
        guard let root = BannerAdView.topViewController() else {
            // Root not ready yet — retry shortly while still pending.
            Task {
                try? await Task.sleep(nanoseconds: 400_000_000)
                if pendingShow {
                    presentIfPossible()
                }
            }
            return
        }
        pendingShow = false
        isShowing = true
        #if DEBUG
        print("App Open: presenting")
        #endif
        appOpenAd.present(fromRootViewController: root)
    }
}

extension AppOpenAdManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        isShowing = false
        appOpenAd = nil
        load()
    }

    func ad(
        _ ad: any GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        #if DEBUG
        print("App Open present failed: \(error.localizedDescription)")
        #endif
        isShowing = false
        appOpenAd = nil
        pendingShow = false
        load()
    }

    func adWillPresentFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        isShowing = true
        pendingShow = false
    }
}
