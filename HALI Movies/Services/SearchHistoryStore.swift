//
//  SearchHistoryStore.swift
//  Hali Cinema
//

import Foundation

@Observable
@MainActor
final class SearchHistoryStore {
    private let key = "hali.cinema.search.history"
    private(set) var history: [String] = []

    init() {
        history = UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func add(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var updated = history.filter { $0.caseInsensitiveCompare(trimmed) != .orderedSame }
        updated.insert(trimmed, at: 0)
        if updated.count > Constants.maxSearchHistory {
            updated = Array(updated.prefix(Constants.maxSearchHistory))
        }
        history = updated
        UserDefaults.standard.set(updated, forKey: key)
    }

    func remove(_ query: String) {
        history.removeAll { $0.caseInsensitiveCompare(query) == .orderedSame }
        UserDefaults.standard.set(history, forKey: key)
    }

    func clear() {
        history = []
        UserDefaults.standard.removeObject(forKey: key)
    }
}
