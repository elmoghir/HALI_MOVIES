//
//  HorizontalMovieSection.swift
//  Hali Cinema
//

import SwiftUI

struct HorizontalMovieSection: View {
    let title: String
    let movies: [Movie]
    let imageBuilder: ImageURLBuilder
    var namespace: Namespace.ID? = nil
    var isLoading: Bool = false
    var onSelect: (Movie) -> Void
    var onFavorite: ((Movie) -> Void)? = nil
    var onAppearLast: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.primaryText)
                .padding(.horizontal, AppTheme.horizontalPadding)
                .accessibilityAddTraits(.isHeader)

            if isLoading && movies.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 14) {
                        ForEach(0..<6, id: \.self) { _ in
                            SkeletonPoster()
                        }
                    }
                    .padding(.horizontal, AppTheme.horizontalPadding)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 14) {
                        ForEach(movies) { movie in
                            MovieCard(
                                movie: movie,
                                posterURL: imageBuilder.posterURL(movie.posterPath),
                                namespace: namespace,
                                onTap: { onSelect(movie) },
                                onFavorite: { onFavorite?(movie) },
                                onShare: {
                                    if let url = movie.tmdbURL {
                                        ShareHelper.shareItems([movie.displayTitle, url])
                                    }
                                },
                                onCopyLink: {
                                    if let url = movie.tmdbURL {
                                        ShareHelper.copyToPasteboard(url.absoluteString)
                                    }
                                }
                            )
                            .onAppear {
                                if movie.id == movies.last?.id {
                                    onAppearLast?()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.horizontalPadding)
                }
            }
        }
    }
}

#Preview {
    HorizontalMovieSection(
        title: "Popular",
        movies: Movie.previews,
        imageBuilder: ImageURLBuilder(),
        onSelect: { _ in }
    )
    .haliScreenBackground()
}
