//
//  ActorCard.swift
//  Hali Cinema
//

import SwiftUI

struct ActorCard: View {
    let member: CastMember
    let imageURL: URL?

    var body: some View {
        VStack(spacing: 8) {
            PosterView(url: imageURL, cornerRadius: 48)
                .frame(width: 96, height: 96)
                .overlay {
                    Circle()
                        .strokeBorder(AppTheme.separator, lineWidth: 1)
                }
                .clipShape(Circle())

            VStack(spacing: 2) {
                Text(member.displayName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.primaryText)
                    .lineLimit(1)
                if let character = member.character {
                    Text(character)
                        .font(.caption2)
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 96)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(member.displayName) as \(member.character ?? "cast")"))
    }
}

#Preview {
    ActorCard(member: .preview, imageURL: nil)
        .padding()
        .haliScreenBackground()
}
