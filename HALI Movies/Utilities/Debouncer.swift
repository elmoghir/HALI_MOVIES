//
//  Debouncer.swift
//  Hali Cinema
//

import Foundation

/// Cancels in-flight work and waits before invoking — used for instant search.
actor Debouncer {
    private var task: Task<Void, Never>?

    func debounce(nanoseconds: UInt64 = Constants.searchDebounceNanoseconds, action: @escaping @Sendable () async -> Void) {
        task?.cancel()
        task = Task {
            do {
                try await Task.sleep(nanoseconds: nanoseconds)
                await action()
            } catch {
                // Cancelled — ignore.
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
