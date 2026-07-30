//
//  SearchBar.swift
//  Hali Cinema
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = String(localized: "Search movies")
    var onVoiceTap: (() -> Void)? = nil
    var onSubmit: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.secondaryText)
                .accessibilityHidden(true)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(AppTheme.primaryText)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }

            if !text.isEmpty {
                Button {
                    text = ""
                    HapticFeedback.light()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppTheme.tertiaryText)
                }
                .accessibilityLabel(Text("Clear search"))
            }

            Button {
                HapticFeedback.light()
                onVoiceTap?()
            } label: {
                Image(systemName: "mic.fill")
                    .foregroundStyle(AppTheme.accent)
                    .frame(minWidth: 44, minHeight: 44)
            }
            .accessibilityLabel(Text("Voice search"))
            .accessibilityHint(Text("Voice search coming soon"))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(AppTheme.separator, lineWidth: 1)
        )
    }
}

#Preview {
    SearchBar(text: .constant(""))
        .padding()
        .haliScreenBackground()
}
