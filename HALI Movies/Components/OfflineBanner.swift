//
//  OfflineBanner.swift
//  Hali Cinema
//

import SwiftUI

struct OfflineBanner: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
            Text("You're offline")
                .font(.subheadline.weight(.semibold))
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(AppTheme.accent.opacity(0.9))
        .accessibilityLabel(Text("You're offline"))
    }
}

#Preview {
    OfflineBanner()
}
