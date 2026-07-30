//
//  MovieRepository.swift
//  Hali Cinema
//

import Foundation

protocol MovieRepositoryProtocol: Sendable {
    func trending(page: Int) async throws -> PagedResponse<Movie>
    func popular(page: Int) async throws -> PagedResponse<Movie>
    func topRated(page: Int) async throws -> PagedResponse<Movie>
    func upcoming(page: Int) async throws -> PagedResponse<Movie>
    func nowPlaying(page: Int) async throws -> PagedResponse<Movie>
    func detail(id: Int) async throws -> MovieDetail
    func credits(id: Int) async throws -> Credits
    func videos(id: Int) async throws -> VideoListResponse
    func images(id: Int) async throws -> MovieImages
    func recommendations(id: Int, page: Int) async throws -> PagedResponse<Movie>
    func similar(id: Int, page: Int) async throws -> PagedResponse<Movie>
    func reviews(id: Int, page: Int) async throws -> PagedResponse<Review>
    func genres() async throws -> [Genre]
}

final class MovieRepository: MovieRepositoryProtocol, Sendable {
    private let client: APIClientProtocol

    init(client: APIClientProtocol) {
        self.client = client
    }

    func trending(page: Int) async throws -> PagedResponse<Movie> {
        try await client.request(TMDbEndpoint.trendingMovies(page: page))
    }

    func popular(page: Int) async throws -> PagedResponse<Movie> {
        try await client.request(TMDbEndpoint.popularMovies(page: page))
    }

    func topRated(page: Int) async throws -> PagedResponse<Movie> {
        try await client.request(TMDbEndpoint.topRatedMovies(page: page))
    }

    func upcoming(page: Int) async throws -> PagedResponse<Movie> {
        try await client.request(TMDbEndpoint.upcomingMovies(page: page))
    }

    func nowPlaying(page: Int) async throws -> PagedResponse<Movie> {
        try await client.request(TMDbEndpoint.nowPlayingMovies(page: page))
    }

    func detail(id: Int) async throws -> MovieDetail {
        try await client.request(TMDbEndpoint.movieDetail(id: id))
    }

    func credits(id: Int) async throws -> Credits {
        try await client.request(TMDbEndpoint.movieCredits(id: id))
    }

    func videos(id: Int) async throws -> VideoListResponse {
        try await client.request(TMDbEndpoint.movieVideos(id: id))
    }

    func images(id: Int) async throws -> MovieImages {
        try await client.request(TMDbEndpoint.movieImages(id: id))
    }

    func recommendations(id: Int, page: Int) async throws -> PagedResponse<Movie> {
        try await client.request(TMDbEndpoint.movieRecommendations(id: id, page: page))
    }

    func similar(id: Int, page: Int) async throws -> PagedResponse<Movie> {
        try await client.request(TMDbEndpoint.movieSimilar(id: id, page: page))
    }

    func reviews(id: Int, page: Int) async throws -> PagedResponse<Review> {
        try await client.request(TMDbEndpoint.movieReviews(id: id, page: page))
    }

    func genres() async throws -> [Genre] {
        let response: GenreListResponse = try await client.request(TMDbEndpoint.movieGenres)
        return response.genres
    }
}
