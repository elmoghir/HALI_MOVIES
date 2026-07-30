//
//  TrailerButton.swift
//  Hali Cinema
//

import SwiftUI

struct TrailerButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticFeedback.medium()
            action()
        }) {
            Label("Watch Trailer", systemImage: "play.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(AppTheme.accent, in: Capsule())
                .frame(minHeight: 44)
        }
        .buttonStyle(.plain)
        .accessibilityHint(Text("Opens the movie trailer"))
    }
}

#Preview {
    TrailerButton(action: {})
        .padding()
        .haliScreenBackground()
}
