# Hali Cinema

Premium SwiftUI movie discovery app powered by [TMDb](https://www.themoviedb.org/).

Hali Cinema does **not** stream video. It presents movie information, trailers, cast, ratings, images, and recommendations with an Apple-first dark design.

## Requirements

- Xcode 16+
- iOS 18+
- A free [TMDb API key](https://www.themoviedb.org/settings/api)

## Setup

1. Copy `Secrets.example.xcconfig` → `Secrets.xcconfig`
2. Paste your keys:

```
TMDB_API_KEY=your_tmdb_key_here
ADMOB_APP_ID=ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy
ADMOB_BANNER_ID=ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzz
ADMOB_INTERSTITIAL_ID=ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzz
ADMOB_APP_OPEN_ID=ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzz
```

While developing, keep Google’s **test** AdMob IDs (already in `Secrets.example.xcconfig`).

3. Open `HALI Movies.xcodeproj` and run the **HALI Movies** scheme

`Secrets.xcconfig` is gitignored. Never commit real keys.

## Ads (AdMob)

- **Banner** — bottom of all tabs (above the tab bar)
- **App Open** — cold start + return from background
- **Interstitial** — when leaving a movie detail (every 2nd dismiss, min 60s gap)

Replace test unit IDs with your AdMob console IDs before App Store release.

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
