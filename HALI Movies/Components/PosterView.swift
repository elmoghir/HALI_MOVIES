//
//  PosterView.swift
//  Hali Cinema
//
//  Cached poster/backdrop via Kingfisher with elegant placeholders.
//

import Kingfisher
import SwiftUI

struct PosterView: View {
    let url: URL?
    var cornerRadius: CGFloat = AppTheme.cardCornerRadius
    var contentMode: SwiftUI.ContentMode = .fill

    var body: some View {
        GeometryReader { proxy in
            KFImage(url)
                .placeholder {
                    ZStack {
                        AppTheme.elevatedBackground
                        Image(systemName: "film")
                            .font(.title2)
                            .foregroundStyle(AppTheme.tertiaryText)
                    }
                }
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .accessibilityHidden(url == nil)
    }
}

#Preview {
    PosterView(url: nil)
        .frame(width: 140, height: 210)
        .padding()
        .haliScreenBackground()
}
