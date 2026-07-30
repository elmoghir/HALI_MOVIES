//
//  HaliCinemaApp.swift
//  Hali Cinema
//
//  Application entry. Wires SwiftData, dependency injection, ads, and the root tab experience.
//
//  Architecture overview:
//  - Views observe @Observable ViewModels
//  - ViewModels talk to Repositories (never URLSession directly)
//  - Repositories use the generic APIClient
//  - Favorites persist via SwiftData for offline access
//  - AdMob: banner (all tabs), App Open (launch/resume), interstitial (leave movie detail)
//

import SwiftData
import SwiftUI

@main
struct HaliCinemaApp: App {
    @State private var environment = AppEnvironment()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.appEnvironment, environment)
                .environment(\.locale, Locale(identifier: "en_US"))
                .modelContainer(environment.modelContainer)
                .preferredColorScheme(.dark)
                .task {
                    await environment.bootstrapAds()
                }
        }
        .onChange(of: scenePhase) { _, newPhase in
            environment.appOpenAds.handleScenePhase(newPhase)
        }
    }
}
