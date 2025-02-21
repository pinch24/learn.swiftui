//
//  ContentView.swift
//  ProgressiveBlur
//
//  Created by Meng To on 20/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            CardView()
                .background(
                    AnimatedMeshGradient()
                        .blendMode(.lighten)
                        .cornerRadius(20)
                )
                .overlay(
                    AnimatedMeshGradient()
                        .mask(RoundedRectangle(cornerRadius: 20).strokeBorder(lineWidth: 10))
                        .blur(radius: 10)
                        .blendMode(.colorDodge)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: 850)
        }
        .background(Image("Background2").resizable().aspectRatio(contentMode: .fill))
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            GeometryReader { proxy in
                VariableBlurView(maxBlurRadius: 10)
                    .frame(height: proxy.safeAreaInsets.top)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    ContentView()
}
