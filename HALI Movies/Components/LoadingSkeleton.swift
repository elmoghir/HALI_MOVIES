//
//  LoadingSkeleton.swift
//  Hali Cinema
//

import SwiftUI

struct SkeletonPoster: View {
    var body: some View {
        RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
            .fill(AppTheme.elevatedBackground)
            .frame(width: AppTheme.cardWidth, height: AppTheme.cardWidth / AppTheme.posterAspectRatio)
            .shimmering()
            .accessibilityHidden(true)
    }
}

struct LoadingSkeleton: View {
    var rows: Int = 3

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppTheme.elevatedBackground)
                .frame(height: 280)
                .padding(.horizontal, AppTheme.horizontalPadding)
                .shimmering()

            ForEach(0..<rows, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 12) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.elevatedBackground)
                        .frame(width: 140, height: 18)
                        .padding(.horizontal, AppTheme.horizontalPadding)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(0..<5, id: \.self) { _ in
                                SkeletonPoster()
                            }
                        }
                        .padding(.horizontal, AppTheme.horizontalPadding)
                    }
                }
            }
        }
        .accessibilityLabel(Text("Loading"))
    }
}

private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .overlay {
                if !reduceMotion {
                    LinearGradient(
                        colors: [
                            .clear,
                            Color.white.opacity(0.12),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .offset(x: phase * 200)
                    .onAppear {
                        withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                            phase = 1
                        }
                    }
                }
            }
            .clipped()
    }
}

extension View {
    func shimmering() -> some View {
        modifier(ShimmerModifier())
    }
}

#Preview {
    LoadingSkeleton()
        .haliScreenBackground()
}
