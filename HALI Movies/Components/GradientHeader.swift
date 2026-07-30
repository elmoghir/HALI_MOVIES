//
//  GradientHeader.swift
//  Hali Cinema
//

import SwiftUI

struct GradientHeader: View {
    let title: String
    let subtitle: String?
    let backdropURL: URL?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PosterView(url: backdropURL, cornerRadius: 0, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: AppTheme.featuredHeight)
                .overlay {
                    LinearGradient(
                        colors: [
                            .clear,
                            AppTheme.background.opacity(0.35),
                            AppTheme.background.opacity(0.95),
                            AppTheme.background
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(AppTheme.primaryText)
                    .lineLimit(2)
                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineLimit(3)
                }
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.bottom, 28)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    GradientHeader(
        title: "Fight Club",
        subtitle: "Mischief. Mayhem. Soap.",
        backdropURL: nil
    )
    .haliScreenBackground()
}
