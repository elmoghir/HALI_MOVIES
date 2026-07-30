//
//  ErrorStateView.swift
//  Hali Cinema
//

import SwiftUI

struct ErrorStateView: View {
    let title: String
    let message: String
    var retryTitle: String = "Try Again"
    var onRetry: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundStyle(AppTheme.accent)
                .accessibilityHidden(true)

            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.primaryText)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            if let onRetry {
                Button(retryTitle) {
                    HapticFeedback.medium()
                    onRetry()
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
                .frame(minHeight: 44)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    ErrorStateView(
        title: "Something went wrong",
        message: "Couldn't load movies.",
        onRetry: {}
    )
    .haliScreenBackground()
}
