//
//  PagedResponse.swift
//  Hali Cinema
//

import Foundation

struct PagedResponse<T: Decodable & Sendable>: Decodable, Sendable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
}
