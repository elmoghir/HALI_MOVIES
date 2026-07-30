//
//  LottieLoadingView.swift
//  Hali Cinema
//

import Lottie
import SwiftUI

struct LottieLoadingView: View {
    var body: some View {
        LottieView(animation: .named("loading"))
            .looping()
            .frame(width: 96, height: 96)
            .accessibilityLabel(Text("Loading"))
    }
}

#Preview {
    LottieLoadingView()
        .haliScreenBackground()
}
