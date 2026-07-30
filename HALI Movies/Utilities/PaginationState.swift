//
//  PaginationState.swift
//  Hali Cinema
//

import Foundation

struct PaginationState: Sendable {
    var page: Int = 0
    var totalPages: Int = 1
    var isLoadingMore = false

    var canLoadMore: Bool {
        page < totalPages && !isLoadingMore
    }

    mutating func reset() {
        page = 0
        totalPages = 1
        isLoadingMore = false
    }

    mutating func apply(responsePage: Int, totalPages: Int) {
        self.page = responsePage
        self.totalPages = max(totalPages, 1)
        isLoadingMore = false
    }
}

enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case failed(String)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
