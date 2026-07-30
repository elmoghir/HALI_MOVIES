//
//  SearchView.swift
//  Hali Cinema
//

import SwiftUI

struct SearchView: View {
    @Environment(\.appEnvironment) private var environment
    @State private var viewModel: SearchViewModel?
    @State private var path = NavigationPath()
    @State private var voiceAlert = false

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
            .navigationTitle("Search")
            .navigationDestination(for: Int.self) { id in
                MovieDetailView(movieID: id)
            }
            .alert("Voice Search", isPresented: $voiceAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Voice search is coming soon.")
            }
        }
        .task {
            if viewModel == nil {
                viewModel = SearchViewModel(
                    searchRepository: environment.searchRepository,
                    searchHistory: environment.searchHistory
                )
            }
        }
    }

    @ViewBuilder
    private func content(_ viewModel: SearchViewModel) -> some View {
        VStack(spacing: 0) {
            if !environment.networkMonitor.isConnected {
                OfflineBanner()
            }

            SearchBar(
                text: Binding(
                    get: { viewModel.query },
                    set: { viewModel.onQueryChanged($0) }
                ),
                onVoiceTap: { voiceAlert = true },
                onSubmit: { viewModel.submit() }
            )
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.vertical, 12)

            switch viewModel.state {
            case .idle:
                idleContent(viewModel)
            case .loading:
                VStack {
                    Spacer()
                    LottieLoadingView()
                    Spacer()
                }
            case .empty:
                EmptyStateView(
                    systemImage: "magnifyingglass",
                    title: String(localized: "No results"),
                    message: String(localized: "Try a different title, actor, or keyword.")
                )
            case .failed(let message):
                ErrorStateView(
                    title: String(localized: "Search failed"),
                    message: message,
                    onRetry: { viewModel.submit() }
                )
            case .loaded:
                resultsGrid(viewModel)
            }
        }
    }

    private func idleContent(_ viewModel: SearchViewModel) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                if !viewModel.history.isEmpty {
                    suggestionBlock(
                        title: String(localized: "Recent"),
                        items: viewModel.history,
                        onSelect: viewModel.selectSuggestion,
                        onDelete: viewModel.removeHistory,
                        trailing: {
                            Button(String(localized: "Clear")) {
                                viewModel.clearHistory()
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(AppTheme.accent)
                        }
                    )
                }

                suggestionBlock(
                    title: String(localized: "Popular Searches"),
                    items: viewModel.popularSearches,
                    onSelect: viewModel.selectSuggestion,
                    onDelete: nil,
                    trailing: { EmptyView() }
                )
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.bottom, 32)
        }
    }

    private func suggestionBlock<Trailing: View>(
        title: String,
        items: [String],
        onSelect: @escaping (String) -> Void,
        onDelete: ((String) -> Void)?,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.primaryText)
                Spacer()
                trailing()
            }

            ForEach(items, id: \.self) { item in
                HStack {
                    Button {
                        HapticFeedback.selection()
                        onSelect(item)
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(AppTheme.tertiaryText)
                            Text(item)
                                .foregroundStyle(AppTheme.primaryText)
                            Spacer()
                        }
                        .frame(minHeight: 44)
                    }
                    .buttonStyle(.plain)

                    if let onDelete {
                        Button {
                            onDelete(item)
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(AppTheme.tertiaryText)
                                .frame(width: 44, height: 44)
                        }
                        .accessibilityLabel(Text("Remove \(item)"))
                    }
                }
            }
        }
    }

    private func resultsGrid(_ viewModel: SearchViewModel) -> some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 140), spacing: 14)
                ],
                spacing: 18
            ) {
                ForEach(viewModel.results) { movie in
                    MovieCard(
                        movie: movie,
                        posterURL: environment.imageURLBuilder.posterURL(movie.posterPath),
                        onTap: { path.append(movie.id) }
                    )
                    .onAppear {
                        if movie.id == viewModel.results.last?.id {
                            Task { await viewModel.loadMore() }
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    SearchView()
        .environment(\.appEnvironment, .preview)
}
