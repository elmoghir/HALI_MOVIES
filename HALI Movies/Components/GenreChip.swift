//
//  GenreChip.swift
//  Hali Cinema
//

import SwiftUI

struct GenreChip: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.caption.weight(.medium))
            .foregroundStyle(AppTheme.primaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(AppTheme.cardBackground, in: Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(AppTheme.separator, lineWidth: 1)
            )
            .accessibilityAddTraits(.isStaticText)
    }
}

#Preview {
    HStack {
        GenreChip(title: "Drama")
        GenreChip(title: "Thriller")
    }
    .padding()
    .haliScreenBackground()
}
