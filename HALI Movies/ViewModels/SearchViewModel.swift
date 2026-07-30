//
//  SearchViewModel.swift
//  Hali Cinema
//

import Foundation

@Observable
@MainActor
final class SearchViewModel {
    private let searchRepository: SearchRepositoryProtocol
    private let searchHistory: SearchHistoryStore
    private let debouncer = Debouncer()

    var query = ""
    var results: [Movie] = []
    var state: LoadState = .idle
    var errorMessage: String?
    var showVoicePlaceholder = false

    private var pagination = PaginationState()
    private var activeQuery = ""

    var history: [String] { searchHistory.history }
    var popularSearches: [String] { Constants.popularSearches }

    init(
        searchRepository: SearchRepositoryProtocol,
        searchHistory: SearchHistoryStore
    ) {
        self.searchRepository = searchRepository
        self.searchHistory = searchHistory
    }

    func onQueryChanged(_ newValue: String) {
        query = newValue
        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            results = []
            state = .idle
            Task { await debouncer.cancel() }
            return
        }

        Task {
            await debouncer.debounce { [weak self] in
                await self?.performSearch(trimmed, reset: true)
            }
        }
    }

    func submit() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        searchHistory.add(trimmed)
        Task { await performSearch(trimmed, reset: true) }
    }

    func selectSuggestion(_ text: String) {
        query = text
        searchHistory.add(text)
        Task { await performSearch(text, reset: true) }
    }

    func removeHistory(_ text: String) {
        searchHistory.remove(text)
    }

    func clearHistory() {
        searchHistory.clear()
    }

    func loadMore() async {
        guard pagination.canLoadMore, !activeQuery.isEmpty else { return }
        pagination.isLoadingMore = true
        do {
            let response = try await searchRepository.searchMovies(query: activeQuery, page: pagination.page + 1)
            results.append(contentsOf: response.results)
            pagination.apply(responsePage: response.page, totalPages: response.totalPages)
        } catch {
            pagination.isLoadingMore = false
        }
    }

    private func performSearch(_ text: String, reset: Bool) async {
        activeQuery = text
        if reset {
            pagination.reset()
            state = .loading
        }
        do {
            let response = try await searchRepository.searchMovies(query: text, page: 1)
            results = response.results
            pagination.apply(responsePage: response.page, totalPages: response.totalPages)
            state = results.isEmpty ? .empty : .loaded
            searchHistory.add(text)
        } catch {
            let mapped = NetworkError.map(error)
            if mapped == .cancelled { return }
            errorMessage = mapped.localizedDescription
            state = .failed(mapped.localizedDescription)
        }
    }
}
