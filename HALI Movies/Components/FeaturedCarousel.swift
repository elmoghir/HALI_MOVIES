//
//  FeaturedCarousel.swift
//  Hali Cinema
//

import Combine
import SwiftUI

struct FeaturedCarousel: View {
    let movies: [Movie]
    let imageBuilder: ImageURLBuilder
    var onSelect: (Movie) -> Void

    @State private var index = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let timer = Timer.publish(every: 4.5, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(movies.prefix(8).enumerated()), id: \.element.id) { offset, movie in
                Button {
                    onSelect(movie)
                } label: {
                    ZStack(alignment: .bottomLeading) {
                        PosterView(
                            url: imageBuilder.backdropURL(movie.backdropPath) ?? imageBuilder.posterURL(movie.posterPath, large: true),
                            cornerRadius: 0,
                            contentMode: .fill
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: AppTheme.featuredHeight)
                        .overlay {
                            LinearGradient(
                                colors: [
                                    .clear,
                                    AppTheme.background.opacity(0.25),
                                    AppTheme.background.opacity(0.9),
                                    AppTheme.background
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Trending Today")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AppTheme.accent)
                                .textCase(.uppercase)
                                .tracking(1.2)

                            Text(movie.displayTitle)
                                .font(.largeTitle.weight(.bold))
                                .foregroundStyle(AppTheme.primaryText)
                                .lineLimit(2)

                            if let overview = movie.overview, !overview.isEmpty {
                                Text(overview)
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .lineLimit(3)
                            }

                            HStack(spacing: 12) {
                                if let score = movie.voteAverage {
                                    RatingBadge(score: score)
                                }
                                if let year = movie.formattedReleaseYear {
                                    Text(year)
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(AppTheme.secondaryText)
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.horizontalPadding)
                        .padding(.bottom, 36)
                    }
                }
                .buttonStyle(.plain)
                .tag(offset)
                .accessibilityLabel(Text("Featured: \(movie.displayTitle)"))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: AppTheme.featuredHeight)
        .onReceive(timer) { _ in
            guard !reduceMotion, movies.count > 1 else { return }
            withAnimation(AppTheme.fade) {
                index = (index + 1) % min(movies.count, 8)
            }
        }
    }
}

#Preview {
    FeaturedCarousel(movies: Movie.previews, imageBuilder: ImageURLBuilder(), onSelect: { _ in })
        .haliScreenBackground()
}
