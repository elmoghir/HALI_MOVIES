//
//  AppRatingPrompt.swift
//  Hali Cinema
//
//  Requests the native App Store rating dialog after a short delay.
//  Note: iOS may suppress the dialog if it was shown too recently.
//

import StoreKit
import SwiftUI

enum AppRatingPrompt {
    private static let lastRequestKey = "hali.cinema.rating.lastRequest"

    /// Asks for a review after `delay` seconds. Skips if already requested in this version.
    @MainActor
    static func schedule(
        delaySeconds: UInt64 = 5,
        requestReview: RequestReviewAction
    ) {
        Task {
            try? await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)

            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
            let key = "\(lastRequestKey).\(version)"
            guard !UserDefaults.standard.bool(forKey: key) else { return }

            requestReview()
            UserDefaults.standard.set(true, forKey: key)
        }
    }
}
