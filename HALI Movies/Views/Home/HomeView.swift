//
//  HomeView.swift
//  Hali Cinema
//

import SwiftUI

struct HomeView: View {
    @Environment(\.appEnvironment) private var environment
    @State private var viewModel: HomeViewModel?
    @State private var path = NavigationPath()
    @Namespace private var heroNamespace

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if let viewModel {
                    content(viewModel)
                } else {
                    ProgressView()
                        .tint(AppTheme.accent)
                }
            }
            .haliScreenBackground()
            .navigationTitle("Hali Cinema")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(for: Int.self) { id in
                MovieDetailView(movieID: id, namespace: heroNamespace)
            }
        }
        .task {
            if viewModel == nil {
                let vm = HomeViewModel(
                    movieRepository: environment.movieRepository,
                    tvRepository: environment.tvRepository,
                    favoritesRepository: environment.favoritesRepository
                )
                viewModel = vm
                await vm.load()
            }
        }
    }

    @ViewBuilder
    private func content(_ viewModel: HomeViewModel) -> some View {
        VStack(spacing: 0) {
            if !environment.networkMonitor.isConnected {
                OfflineBanner()
            }

            switch viewModel.state {
            case .loading, .idle where viewModel.trending.isEmpty:
                ScrollView {
                    LoadingSkeleton()
                        .padding(.top, 8)
                }
            case .failed(let message):
                ErrorStateView(
                    title: String(localized: "Couldn't load home"),
                    message: message,
                    onRetry: { Task { await viewModel.load() } }
                )
            case .empty:
                EmptyStateView(
                    systemImage: "film",
                    title: String(localized: "Nothing to show"),
                    message: String(localized: "Check your API key in Secrets.xcconfig and try again.")
                )
            default:
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                        if !viewModel.trending.isEmpty {
                            FeaturedCarousel(
                                movies: viewModel.trending,
                                imageBuilder: environment.imageURLBuilder,
                                onSelect: { path.append($0.id) }
                            )
                        }

                        section("Popular Movies", movies: viewModel.popular, onMore: { await viewModel.loadMorePopular() })
                        section("Top Rated", movies: viewModel.topRated, onMore: { await viewModel.loadMoreTopRated() })
                        section("Upcoming", movies: viewModel.upcoming, onMore: { await viewModel.loadMoreUpcoming() })
                        section("Now Playing", movies: viewModel.nowPlaying, onMore: { await viewModel.loadMoreNowPlaying() })
                        section("Popular TV Shows", movies: viewModel.popularTV, onMore: { await viewModel.loadMoreTV() })
                    }
                    .padding(.bottom, 32)
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
    }

    private func section(
        _ title: String,
        movies: [Movie],
        onMore: @escaping () async -> Void
    ) -> some View {
        HorizontalMovieSection(
            title: title,
            movies: movies,
            imageBuilder: environment.imageURLBuilder,
            namespace: heroNamespace,
            isLoading: movies.isEmpty,
            onSelect: { path.append($0.id) },
            onFavorite: { viewModel?.toggleFavorite($0) },
            onAppearLast: { Task { await onMore() } }
        )
    }
}

#Preview {
    HomeView()
        .environment(\.appEnvironment, .preview)
}
