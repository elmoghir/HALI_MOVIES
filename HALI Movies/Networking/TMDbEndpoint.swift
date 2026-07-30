//
//  TMDbEndpoint.swift
//  Hali Cinema
//
//  All TMDb v3 routes used by Hali Cinema.
//

import Foundation

enum TMDbEndpoint: Endpoint {
    case configuration
    case trendingMovies(page: Int)
    case popularMovies(page: Int)
    case topRatedMovies(page: Int)
    case upcomingMovies(page: Int)
    case nowPlayingMovies(page: Int)
    case popularTV(page: Int)
    case movieDetail(id: Int)
    case movieCredits(id: Int)
    case movieVideos(id: Int)
    case movieImages(id: Int)
    case movieRecommendations(id: Int, page: Int)
    case movieSimilar(id: Int, page: Int)
    case movieReviews(id: Int, page: Int)
    case searchMovies(query: String, page: Int)
    case movieGenres
    case tvGenres

    var path: String {
        switch self {
        case .configuration:
            return "/configuration"
        case .trendingMovies:
            return "/trending/movie/day"
        case .popularMovies:
            return "/movie/popular"
        case .topRatedMovies:
            return "/movie/top_rated"
        case .upcomingMovies:
            return "/movie/upcoming"
        case .nowPlayingMovies:
            return "/movie/now_playing"
        case .popularTV:
            return "/tv/popular"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .movieCredits(let id):
            return "/movie/\(id)/credits"
        case .movieVideos(let id):
            return "/movie/\(id)/videos"
        case .movieImages(let id):
            return "/movie/\(id)/images"
        case .movieRecommendations(let id, _):
            return "/movie/\(id)/recommendations"
        case .movieSimilar(let id, _):
            return "/movie/\(id)/similar"
        case .movieReviews(let id, _):
            return "/movie/\(id)/reviews"
        case .searchMovies:
            return "/search/movie"
        case .movieGenres:
            return "/genre/movie/list"
        case .tvGenres:
            return "/genre/tv/list"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .configuration, .movieCredits, .movieVideos, .movieImages, .movieGenres, .tvGenres:
            return []
        case .trendingMovies(let page),
             .popularMovies(let page),
             .topRatedMovies(let page),
             .upcomingMovies(let page),
             .nowPlayingMovies(let page),
             .popularTV(let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .movieDetail:
            return [URLQueryItem(name: "append_to_response", value: "credits,videos,images,recommendations,similar,reviews")]
        case .movieRecommendations(_, let page),
             .movieSimilar(_, let page),
             .movieReviews(_, let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .searchMovies(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "include_adult", value: "false")
            ]
        }
    }
}
