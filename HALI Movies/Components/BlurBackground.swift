//
//  BlurBackground.swift
//  Hali Cinema
//

import SwiftUI

struct BlurBackground: View {
    let url: URL?

    var body: some View {
        ZStack {
            AppTheme.background
            PosterView(url: url, cornerRadius: 0, contentMode: .fill)
                .blur(radius: 40)
                .opacity(0.45)
                .scaleEffect(1.1)
            LinearGradient(
                colors: [
                    AppTheme.background.opacity(0.2),
                    AppTheme.background.opacity(0.85),
                    AppTheme.background
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

#Preview {
    BlurBackground(url: nil)
}
