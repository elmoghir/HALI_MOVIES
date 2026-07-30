//
//  RatingBadge.swift
//  Hali Cinema
//

import SwiftUI

struct RatingBadge: View {
    let score: Double?
    var compact: Bool = false

    private var display: String {
        guard let score, score > 0 else { return "–" }
        return String(format: "%.1f", score)
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(compact ? .caption2 : .caption)
                .foregroundStyle(.yellow)
            Text(display)
                .font(compact ? .caption2.weight(.semibold) : .caption.weight(.semibold))
                .foregroundStyle(AppTheme.primaryText)
                .monospacedDigit()
        }
        .padding(.horizontal, compact ? 6 : 8)
        .padding(.vertical, compact ? 3 : 5)
        .background(.ultraThinMaterial, in: Capsule())
        .accessibilityLabel(Text("Rating \(display) out of 10"))
    }
}

#Preview {
    RatingBadge(score: 8.4)
        .padding()
        .haliScreenBackground()
}
