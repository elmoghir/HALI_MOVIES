//
//  View+Accessibility.swift
//  Hali Cinema
//

import SwiftUI

extension View {
    /// Ensures interactive controls meet Apple's 44pt minimum tap target.
    func haliTapTarget() -> some View {
        self.frame(minWidth: 44, minHeight: 44)
    }
}
