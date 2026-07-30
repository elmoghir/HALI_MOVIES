//
//  NetworkMonitor.swift
//  Hali Cinema
//

import Foundation
import Network

@Observable
@MainActor
final class NetworkMonitor {
    private(set) var isConnected = true
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.halicinema.networkmonitor")

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        // NWPathMonitor.cancel is thread-safe.
        monitor.cancel()
    }
}
