//
//  ProfileView.swift
//  Hali Cinema
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.accent.opacity(0.2))
                                .frame(width: 64, height: 64)
                            Image(systemName: "film.stack.fill")
                                .font(.title)
                                .foregroundStyle(AppTheme.accent)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hali Cinema")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(AppTheme.primaryText)
                            Text("Discover. Save. Remember.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(AppTheme.secondaryBackground)
                }

                Section("Appearance") {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Dark Mode")
                            Text("Always on for a cinema-first experience")
                                .font(.caption)
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                    } icon: {
                        Image(systemName: "moon.fill")
                            .foregroundStyle(AppTheme.accent)
                    }
                    .listRowBackground(AppTheme.secondaryBackground)
                }

                Section("About") {
                    LabeledContent("Version", value: AppConfiguration.appVersion)
                        .listRowBackground(AppTheme.secondaryBackground)

                    NavigationLink {
                        aboutTMDb
                    } label: {
                        Label("TMDb Credits", systemImage: "hands.sparkles")
                    }
                    .listRowBackground(AppTheme.secondaryBackground)

                    NavigationLink {
                        privacyPlaceholder
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    .listRowBackground(AppTheme.secondaryBackground)

                    NavigationLink {
                        aboutApp
                    } label: {
                        Label("About Hali Cinema", systemImage: "info.circle")
                    }
                    .listRowBackground(AppTheme.secondaryBackground)
                }
            }
            .scrollContentBackground(.hidden)
            .haliScreenBackground()
            .navigationTitle("Profile")
        }
    }

    private var aboutTMDb: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("This product uses the TMDb API but is not endorsed or certified by TMDb.")
                    .font(.body)
                    .foregroundStyle(AppTheme.secondaryText)
                Link("themoviedb.org", destination: URL(string: "https://www.themoviedb.org")!)
                    .foregroundStyle(AppTheme.accent)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .haliScreenBackground()
        .navigationTitle("TMDb Credits")
    }

    private var privacyPlaceholder: some View {
        ScrollView {
            Text("Privacy Policy placeholder. Hali Cinema stores favorites and search history only on your device. No personal account is required.")
                .font(.body)
                .foregroundStyle(AppTheme.secondaryText)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .haliScreenBackground()
        .navigationTitle("Privacy Policy")
    }

    private var aboutApp: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Hali Cinema is a premium movie discovery companion. Browse trending titles, trailers, cast, and ratings — without streaming.")
                    .foregroundStyle(AppTheme.secondaryText)
                Text("Built with SwiftUI, SwiftData, and the Observation framework.")
                    .foregroundStyle(AppTheme.secondaryText)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .haliScreenBackground()
        .navigationTitle("About")
    }
}

#Preview {
    ProfileView()
}
