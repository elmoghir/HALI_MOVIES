# Hali Cinema

Premium SwiftUI movie discovery app powered by [TMDb](https://www.themoviedb.org/).

Hali Cinema does **not** stream video. It presents movie information, trailers, cast, ratings, images, and recommendations with an Apple-first dark design.

## Requirements

- Xcode 16+
- iOS 18+
- A free [TMDb API key](https://www.themoviedb.org/settings/api)

## Setup

1. Copy `Secrets.example.xcconfig` → `Secrets.xcconfig`
2. Paste your API key:

```
TMDB_API_KEY = your_key_here
```

3. Open `HALI Movies.xcodeproj` and run the **HALI Movies** scheme

`Secrets.xcconfig` is gitignored. Never commit real keys.

## Architecture

```
Views → ViewModels (@Observable) → Repositories → APIClient (URLSession)
                                 ↘ SwiftData (Favorites)
```

- **MVVM** with the Observation framework
- **Dependency injection** via `AppEnvironment`
- **Generic networking** (`APIClient` + `TMDbEndpoint`)
- **Kingfisher** image caching, **Lottie** loading animation
- **SwiftData** offline favorites

## Tabs

Home · Search · Favorites · Profile

## License / Attribution

This product uses the TMDb API but is not endorsed or certified by TMDb.
