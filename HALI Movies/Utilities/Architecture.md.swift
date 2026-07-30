//
//  Architecture.md.swift
//  Hali Cinema
//
//  Documentation-as-code: architecture notes (compiled as comments only).
//

/*
 # Architecture

 ## Layers
 1. **Views** — SwiftUI screens & reusable Components. No networking.
 2. **ViewModels** — `@Observable` + `@MainActor`. Own LoadState, pagination, user intents.
 3. **Repositories** — Map TMDb endpoints to domain models. Protocol-backed for tests.
 4. **Networking** — Generic `APIClient` over URLSession (timeout, cancellation, typed errors).
 5. **Persistence** — SwiftData `FavoriteMovie` for offline favorites; UserDefaults search history.

 ## Dependency Injection
 `AppEnvironment` is created once in `HaliCinemaApp` and injected via
 `.environment(\.appEnvironment, ...)`. ViewModels receive repositories from it.

 ## Networking
 `TMDbEndpoint` describes path + query. `APIClient.request<T: Decodable>` appends `api_key`,
 decodes with snake_case strategy, and maps URL/HTTP failures to `NetworkError`.

 ## Theme
 Pure black canvas, accent #E50914, glass materials, 24pt continuous corners — see `AppTheme`.

 ## Extending
 - New TMDb route → add case to `TMDbEndpoint` + repository method
 - New screen → View + ViewModel + optional repository
 - Widgets / Spotlight → see `WidgetSharedModels` and `SpotlightIndexer` prep hooks
 */

enum ArchitectureDoc {
    // Namespace only — keeps this documentation file in the target.
}
