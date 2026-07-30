//
//  FavoritesView.swift
//  Hali Cinema
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.appEnvironment) private var environment
    @State private var viewModel: FavoritesViewModel?
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if let viewModel {
                    content(viewModel)
                } else {
                    ProgressView().tint(AppTheme.accent)
                }
            }
            .haliScreenBackground()
            .navigationTitle("Favorites")
            .navigationDestination(for: Int.self) { id in
                MovieDetailView(movieID: id)
            }
            .onAppear {
                viewModel?.load()
            }
        }
        .task {
            if viewModel == nil {
                let vm = FavoritesViewModel(favoritesRepository: environment.favoritesRepository)
                viewModel = vm
                vm.load()
            }
        }
    }

    @ViewBuilder
    private func content(_ viewModel: FavoritesViewModel) -> some View {
        if viewModel.favorites.isEmpty {
            EmptyStateView(
                systemImage: "heart",
                title: String(localized: "No favorites yet"),
                message: String(localized: "Save movies you love — they'll stay available offline.")
            )
        } else {
            List {
                ForEach(viewModel.favorites, id: \.tmdbId) { favorite in
                    Button {
                        path.append(favorite.tmdbId)
                    } label: {
                        HStack(spacing: 14) {
                            PosterView(
                                url: environment.imageURLBuilder.posterURL(favorite.posterPath),
                                cornerRadius: 14
                            )
                            .frame(width: 64, height: 96)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(favorite.title)
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.primaryText)
                                    .lineLimit(2)
                                if let date = favorite.releaseDate {
                                    Text(date)
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.secondaryText)
                                }
                                RatingBadge(score: favorite.voteAverage, compact: true)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(AppTheme.tertiaryText)
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(AppTheme.secondaryBackground)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.remove(id: favorite.tmdbId)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                    .contextMenu {
                        Button("Remove Favorite", systemImage: "heart.slash", role: .destructive) {
                            viewModel.remove(id: favorite.tmdbId)
                        }
                        if let url = favorite.asMovie.tmdbURL {
                            Button("Share", systemImage: "square.and.arrow.up") {
                                ShareHelper.shareItems([favorite.title, url])
                            }
                            Button("Copy Link", systemImage: "link") {
                                ShareHelper.copyToPasteboard(url.absoluteString)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
    }
}

#Preview {
    FavoritesView()
        .environment(\.appEnvironment, .preview)
}
