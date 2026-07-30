//
//  HaliCinemaApp.swift
//  Hali Cinema
//
//  Application entry. Wires SwiftData, dependency injection, and the root tab experience.
//
//  Architecture overview:
//  - Views observe @Observable ViewModels
//  - ViewModels talk to Repositories (never URLSession directly)
//  - Repositories use the generic APIClient
//  - Favorites persist via SwiftData for offline access
//

import SwiftData
import SwiftUI

@main
struct HaliCinemaApp: App {
    @State private var environment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.appEnvironment, environment)
                .modelContainer(environment.modelContainer)
                .preferredColorScheme(.dark)
        }
    }
}
