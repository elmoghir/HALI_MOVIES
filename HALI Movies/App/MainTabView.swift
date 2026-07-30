//
//  MainTabView.swift
//  Hali Cinema
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.appEnvironment) private var environment
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        VStack(spacing: 0) {
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

            // Banner sits under the tab bar so Home / Search / Favorites / Profile stay visible.
            BottomBannerChrome()
        }
        .haliScreenBackground()
        .task {
            AppRatingPrompt.schedule(delaySeconds: 5, requestReview: requestReview)
            await environment.bootstrap()
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.appEnvironment, .preview)
}
