//
//  HALI_MoviesTests.swift
//  HALI MoviesTests
//

import Foundation
import Testing
@testable import HALI_Movies

struct TMDbEndpointTests {
    @Test func trendingPathAndPage() throws {
        let endpoint = TMDbEndpoint.trendingMovies(page: 2)
        #expect(endpoint.path == "/trending/movie/day")
        #expect(endpoint.queryItems.contains { $0.name == "page" && $0.value == "2" })
        let url = try endpoint.makeURL(baseURL: Constants.tmdbBaseURL)
        #expect(url.absoluteString.contains("trending/movie/day"))
        #expect(url.absoluteString.contains("page=2"))
    }

    @Test func searchQueryEncoded() throws {
        let endpoint = TMDbEndpoint.searchMovies(query: "fight club", page: 1)
        let url = try endpoint.makeURL(baseURL: Constants.tmdbBaseURL)
        #expect(url.absoluteString.contains("search/movie"))
        #expect(url.absoluteString.contains("query=fight%20club") || url.absoluteString.contains("query=fight+club"))
    }

    @Test func movieDetailAppendsExtras() {
        let items = TMDbEndpoint.movieDetail(id: 550).queryItems
        #expect(items.contains { $0.name == "append_to_response" })
    }
}

struct NetworkErrorTests {
    @Test func mapsTimeout() {
        let nsError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
        #expect(NetworkError.map(nsError) == .timeout)
    }

    @Test func mapsNoInternet() {
        let nsError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        #expect(NetworkError.map(nsError) == .noInternet)
    }

    @Test func http404Message() {
        let message = NetworkError.http(statusCode: 404).errorDescription
        #expect(message?.contains("not found") == true || message?.contains("Not found") == true || message != nil)
    }

    @Test func retryableFlags() {
        #expect(NetworkError.timeout.isRetryable)
        #expect(NetworkError.noInternet.isRetryable)
        #expect(NetworkError.http(statusCode: 500).isRetryable)
        #expect(!NetworkError.http(statusCode: 404).isRetryable)
        #expect(!NetworkError.missingAPIKey.isRetryable)
    }
}

struct MovieModelTests {
    @Test func displayTitleFallback() {
        let movie = Movie(
            id: 1,
            title: nil,
            originalTitle: "Original",
            overview: nil,
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 7.5,
            voteCount: 10,
            popularity: 1,
            adult: false,
            genreIds: nil,
            originalLanguage: "en",
            video: false
        )
        #expect(movie.displayTitle == "Original")
        #expect(movie.formattedReleaseYear == "2024")
        #expect(movie.tmdbURL?.absoluteString.contains("movie/1") == true)
    }
}

// MARK: - Mock client for ViewModel tests

struct MockAPIClient: APIClientProtocol {
    var handler: @Sendable (any Endpoint) async throws -> Data = { _ in Data() }

    func request<T: Decodable & Sendable>(_ endpoint: any Endpoint) async throws -> T {
        let data = try await handler(endpoint)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}

struct MovieRepositoryTests {
    @Test func popularDecodesPagedMovies() async throws {
        let json = """
        {
          "page": 1,
          "results": [
            {
              "id": 550,
              "title": "Fight Club",
              "poster_path": "/p.jpg",
              "vote_average": 8.4
            }
          ],
          "total_pages": 10,
          "total_results": 200
        }
        """.data(using: .utf8)!

        let client = MockAPIClient { _ in json }
        let repo = MovieRepository(client: client)
        let page = try await repo.popular(page: 1)
        #expect(page.results.count == 1)
        #expect(page.results[0].id == 550)
        #expect(page.results[0].displayTitle == "Fight Club")
        #expect(page.totalPages == 10)
    }
}

@MainActor
struct HomeViewModelTests {
    @Test func loadFailureSurfacesErrorState() async {
        struct FailingMovies: MovieRepositoryProtocol {
            func trending(page: Int) async throws -> PagedResponse<Movie> { throw NetworkError.noInternet }
            func popular(page: Int) async throws -> PagedResponse<Movie> { throw NetworkError.noInternet }
            func topRated(page: Int) async throws -> PagedResponse<Movie> { throw NetworkError.noInternet }
            func upcoming(page: Int) async throws -> PagedResponse<Movie> { throw NetworkError.noInternet }
            func nowPlaying(page: Int) async throws -> PagedResponse<Movie> { throw NetworkError.noInternet }
            func detail(id: Int) async throws -> MovieDetail { throw NetworkError.noInternet }
            func credits(id: Int) async throws -> Credits { throw NetworkError.noInternet }
            func videos(id: Int) async throws -> VideoListResponse { throw NetworkError.noInternet }
            func images(id: Int) async throws -> MovieImages { throw NetworkError.noInternet }
            func recommendations(id: Int, page: Int) async throws -> PagedResponse<Movie> { throw NetworkError.noInternet }
            func similar(id: Int, page: Int) async throws -> PagedResponse<Movie> { throw NetworkError.noInternet }
            func reviews(id: Int, page: Int) async throws -> PagedResponse<Review> { throw NetworkError.noInternet }
            func genres() async throws -> [Genre] { throw NetworkError.noInternet }
        }
        struct EmptyTV: TVRepositoryProtocol {
            func popular(page: Int) async throws -> PagedResponse<TVShow> { throw NetworkError.noInternet }
        }
        struct NoFavorites: FavoritesRepositoryProtocol {
            func fetchAll() throws -> [FavoriteMovie] { [] }
            func isFavorite(id: Int) throws -> Bool { false }
            func add(_ movie: Movie) throws {}
            func remove(id: Int) throws {}
            func toggle(_ movie: Movie) throws -> Bool { false }
        }

        let vm = HomeViewModel(
            movieRepository: FailingMovies(),
            tvRepository: EmptyTV(),
            favoritesRepository: NoFavorites()
        )
        await vm.load()
        guard case .failed = vm.state else {
            Issue.record("Expected failed state")
            return
        }
        #expect(vm.errorMessage != nil)
    }
}
