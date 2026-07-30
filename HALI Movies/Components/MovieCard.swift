//
//  MovieCard.swift
//  Hali Cinema
//

import SwiftUI

struct MovieCard: View {
    let movie: Movie
    let posterURL: URL?
    var namespace: Namespace.ID? = nil
    var onTap: (() -> Void)? = nil
    var onFavorite: (() -> Void)? = nil
    var onShare: (() -> Void)? = nil
    var onCopyLink: (() -> Void)? = nil

    var body: some View {
        Button {
            HapticFeedback.selection()
            onTap?()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    Group {
                        if let namespace {
                            PosterView(url: posterURL)
                                .matchedGeometryEffect(id: "poster-\(movie.id)", in: namespace)
                        } else {
                            PosterView(url: posterURL)
                        }
                    }
                    .frame(width: AppTheme.cardWidth, height: AppTheme.cardWidth / AppTheme.posterAspectRatio)
                    .shadow(color: AppTheme.cardShadow, radius: 10, y: 6)

                    if let score = movie.voteAverage, score > 0 {
                        RatingBadge(score: score, compact: true)
                            .padding(8)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(movie.displayTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.primaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    if let year = movie.formattedReleaseYear {
                        Text(year)
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
                .frame(width: AppTheme.cardWidth, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .contextMenu {
            if let onFavorite {
                Button("Add to Favorites", systemImage: "heart") { onFavorite() }
            }
            if let onShare {
                Button("Share", systemImage: "square.and.arrow.up") { onShare() }
            }
            if let onCopyLink {
                Button("Copy Link", systemImage: "link") { onCopyLink() }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(movie.displayTitle), \(movie.formattedReleaseYear ?? "")"))
        .accessibilityHint(Text("Shows movie details"))
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    MovieCard(movie: .preview, posterURL: nil)
        .padding()
        .haliScreenBackground()
}
