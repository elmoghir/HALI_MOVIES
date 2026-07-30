//
//  BannerAdView.swift
//  Hali Cinema
//
//  Adaptive anchored banner for the bottom of MainTabView (all tabs).
//

import GoogleMobileAds
import SwiftUI
import UIKit

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = adUnitID
        banner.backgroundColor = .black
        banner.delegate = context.coordinator
        banner.rootViewController = Self.topViewController()
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        if uiView.rootViewController == nil {
            uiView.rootViewController = Self.topViewController()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    static func topViewController(
        base: UIViewController? = {
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            let window = scenes
                .flatMap(\.windows)
                .first(where: \.isKeyWindow)
                ?? scenes.first?.windows.first
            return window?.rootViewController
        }()
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }

    final class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {}

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            #if DEBUG
            print("Banner failed: \(error.localizedDescription)")
            #endif
        }
    }
}

/// Banner chrome pinned under the tab bar (Home / Search / Favorites / Profile stay visible).
struct BottomBannerChrome: View {
    var body: some View {
        VStack(spacing: 0) {
            Divider().overlay(AppTheme.separator)
            BannerAdView(adUnitID: AdConfig.bannerAdUnitID)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(AppTheme.background)
        }
        .background(AppTheme.background)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("Advertisement"))
    }
}

#Preview {
    BottomBannerChrome()
        .haliScreenBackground()
}
