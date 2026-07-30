//
//  Credits.swift
//  Hali Cinema
//

import Foundation

struct Credits: Codable, Sendable {
    let cast: [CastMember]
    let crew: [CrewMember]

    var director: CrewMember? {
        crew.first { $0.job?.lowercased() == "director" }
    }
}

struct CastMember: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let name: String?
    let character: String?
    let profilePath: String?
    let order: Int?
    let knownForDepartment: String?

    var displayName: String { name ?? "Unknown" }
}

struct CrewMember: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let name: String?
    let job: String?
    let department: String?
    let profilePath: String?

    var displayName: String { name ?? "Unknown" }
}

extension CastMember {
    static let preview = CastMember(
        id: 819,
        name: "Edward Norton",
        character: "The Narrator",
        profilePath: "/5XBzD5WuTyVQZeS4VI25z2moMeY.jpg",
        order: 0,
        knownForDepartment: "Acting"
    )
}
