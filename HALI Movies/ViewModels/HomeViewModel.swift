//
//  HomeViewModel.swift
//  Hali Cinema
//

import Foundation

@Observable
@MainActor
final class HomeViewModel {
    private let movieRepository: MovieRepositoryProtocol
    private let tvRepository: TVRepositoryProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol

    var trending: [Movie] = []
    var popular: [Movie] = []
    var topRated: [Movie] = []
    var upcoming: [Movie] = []
    var nowPlaying: [Movie] = []
    var popularTV: [Movie] = []

    var state: LoadState = .idle
    var errorMessage: String?

    private var popularPage = PaginationState()
    private var topRatedPage = PaginationState()
    private var upcomingPage = PaginationState()
    private var nowPlayingPage = PaginationState()
    private var tvPage = PaginationState()

    init(
        movieRepository: MovieRepositoryProtocol,
        tvRepository: TVRepositoryProtocol,
        favoritesRepository: FavoritesRepositoryProtocol
    ) {
        self.movieRepository = movieRepository
        self.tvRepository = tvRepository
        self.favoritesRepository = favoritesRepository
    }

    func load() async {
        guard state != .loading else { return }
        state = .loading
        errorMessage = nil

        do {
            async let trendingReq = movieRepository.trending(page: 1)
            async let popularReq = movieRepository.popular(page: 1)
            async let topRatedReq = movieRepository.topRated(page: 1)
            async let upcomingReq = movieRepository.upcoming(page: 1)
            async let nowPlayingReq = movieRepository.nowPlaying(page: 1)
            async let tvReq = tvRepository.popular(page: 1)

            let (t, p, tr, u, n, tv) = try await (trendingReq, popularReq, topRatedReq, upcomingReq, nowPlayingReq, tvReq)

            trending = t.results
            popular = p.results
            topRated = tr.results
            upcoming = u.results
            nowPlaying = n.results
            popularTV = tv.results.map { $0.asMovieProxy() }

            popularPage.apply(responsePage: p.page, totalPages: p.totalPages)
            topRatedPage.apply(responsePage: tr.page, totalPages: tr.totalPages)
            upcomingPage.apply(responsePage: u.page, totalPages: u.totalPages)
            nowPlayingPage.apply(responsePage: n.page, totalPages: n.totalPages)
            tvPage.apply(responsePage: tv.page, totalPages: tv.totalPages)

            WidgetDataBridge.saveTrending(t.results)

            state = trending.isEmpty && popular.isEmpty ? .empty : .loaded
        } catch {
            let mapped = NetworkError.map(error)
            if mapped == .cancelled { return }
            errorMessage = mapped.localizedDescription
            state = .failed(mapped.localizedDescription)
        }
    }

    func refresh() async {
        popularPage.reset()
        topRatedPage.reset()
        upcomingPage.reset()
        nowPlayingPage.reset()
        tvPage.reset()
        state = .idle
        await load()
    }

    func loadMorePopular() async {
        await loadMoreMovies(current: \.popular, pagination: \.popularPage) { [movieRepository] page in
            try await movieRepository.popular(page: page)
        }
    }

    func loadMoreTopRated() async {
        await loadMoreMovies(current: \.topRated, pagination: \.topRatedPage) { [movieRepository] page in
            try await movieRepository.topRated(page: page)
        }
    }

    func loadMoreUpcoming() async {
        await loadMoreMovies(current: \.upcoming, pagination: \.upcomingPage) { [movieRepository] page in
            try await movieRepository.upcoming(page: page)
        }
    }

    func loadMoreNowPlaying() async {
        await loadMoreMovies(current: \.nowPlaying, pagination: \.nowPlayingPage) { [movieRepository] page in
            try await movieRepository.nowPlaying(page: page)
        }
    }

    func loadMoreTV() async {
        guard tvPage.canLoadMore else { return }
        tvPage.isLoadingMore = true
        do {
            let response = try await tvRepository.popular(page: tvPage.page + 1)
            popularTV.append(contentsOf: response.results.map { $0.asMovieProxy() })
            tvPage.apply(responsePage: response.page, totalPages: response.totalPages)
        } catch {
            tvPage.isLoadingMore = false
        }
    }

    func toggleFavorite(_ movie: Movie) {
        do {
            _ = try favoritesRepository.toggle(movie)
            HapticFeedback.success()
        } catch {
            // Silent — favorites are best-effort from home cards.
        }
    }

    private func loadMoreMovies(
        current: ReferenceWritableKeyPath<HomeViewModel, [Movie]>,
        pagination: ReferenceWritableKeyPath<HomeViewModel, PaginationState>,
        request: (Int) async throws -> PagedResponse<Movie>
    ) async {
        guard self[keyPath: pagination].canLoadMore else { return }
        self[keyPath: pagination].isLoadingMore = true
        do {
            let nextPage = self[keyPath: pagination].page + 1
            let response = try await request(nextPage)
            self[keyPath: current].append(contentsOf: response.results)
            self[keyPath: pagination].apply(responsePage: response.page, totalPages: response.totalPages)
        } catch {
            self[keyPath: pagination].isLoadingMore = false
        }
    }
}
