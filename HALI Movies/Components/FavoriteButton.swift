//
//  FavoriteButton.swift
//  Hali Cinema
//

import SwiftUI

struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void

    @State private var scale: CGFloat = 1

    var body: some View {
        Button {
            withAnimation(AppTheme.quickSpring) {
                scale = 1.25
            }
            HapticFeedback.success()
            action()
            withAnimation(AppTheme.spring) {
                scale = 1
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title3.weight(.semibold))
                .foregroundStyle(isFavorite ? AppTheme.accent : AppTheme.primaryText)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial, in: Circle())
                .scaleEffect(scale)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(isFavorite ? "Remove from favorites" : "Add to favorites"))
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    HStack {
        FavoriteButton(isFavorite: false, action: {})
        FavoriteButton(isFavorite: true, action: {})
    }
    .padding()
    .haliScreenBackground()
}
