//
//  AppTheme.swift
//  Hali Cinema
//
//  Design tokens for the premium dark cinema experience.
//

import SwiftUI

/// Central visual language: pure black canvas, Netflix-red accent, glass cards.
enum AppTheme {
    // MARK: - Colors

    static let background = Color.black
    static let accent = Color(red: 0.898, green: 0.035, blue: 0.078) // #E50914
    static let secondaryBackground = Color(white: 0.08)
    static let elevatedBackground = Color(white: 0.12)
    static let cardBackground = Color.white.opacity(0.08)
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.65)
    static let tertiaryText = Color.white.opacity(0.4)
    static let separator = Color.white.opacity(0.12)

    // MARK: - Metrics

    static let cardCornerRadius: CGFloat = 24
    static let chipCornerRadius: CGFloat = 12
    static let posterAspectRatio: CGFloat = 2 / 3
    static let backdropAspectRatio: CGFloat = 16 / 9
    static let horizontalPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 28
    static let cardWidth: CGFloat = 140
    static let featuredHeight: CGFloat = 480

    // MARK: - Shadows

    static let cardShadow = Color.black.opacity(0.45)
    static let cardShadowRadius: CGFloat = 16
    static let cardShadowY: CGFloat = 8

    // MARK: - Animation

    static let spring = Animation.spring(response: 0.45, dampingFraction: 0.82)
    static let quickSpring = Animation.spring(response: 0.32, dampingFraction: 0.78)
    static let fade = Animation.easeInOut(duration: 0.28)
}

// MARK: - View helpers

extension View {
    /// Glass-style card surface used across home, search, and favorites.
    func haliCardStyle() -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
            .shadow(
                color: AppTheme.cardShadow,
                radius: AppTheme.cardShadowRadius,
                y: AppTheme.cardShadowY
            )
    }

    func haliScreenBackground() -> some View {
        self
            .background(AppTheme.background.ignoresSafeArea())
            .preferredColorScheme(.dark)
    }
}
