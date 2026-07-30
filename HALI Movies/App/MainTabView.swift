//
//  MainTabView.swift
//  Hali Cinema
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.appEnvironment) private var environment

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
            }
            Tab("Favorites", systemImage: "heart.fill") {
                FavoritesView()
            }
            Tab("Profile", systemImage: "person.fill") {
                ProfileView()
            }
        }
        .tint(AppTheme.accent)
        .haliScreenBackground()
        .task {
            await environment.bootstrap()
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.appEnvironment, .preview)
}
