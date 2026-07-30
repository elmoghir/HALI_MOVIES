//
//  String+Formatting.swift
//  Hali Cinema
//

import Foundation

extension String {
    var nilIfEmpty: String? {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : self
    }
}
