//
//  SplitHStackDemoView.swift
//  GeometryReader
//
//  Created by pinch24 on 9/11/24.
//

import SwiftUI

struct SplitHStackDemoView: View {
    var body: some View {
        RatioSplitHStack(leftWidthRatio: 0.25) {
            Rectangle().fill(.red)
        } rightContent: {
            Color.clear
                .overlay(Text("Hello, world!"))
        }
        .border(.blue)
        .frame(width: 300, height: 60)
    }
}

struct RatioSplitHStack<L, R>: View where L: View, R: View {
    let leftWidthRatio: CGFloat
    let leftContent: L
    let rightContent: R
    init(leftWidthRatio: CGFloat, @ViewBuilder leftContent: @escaping () -> L, @ViewBuilder rightContent: @escaping () -> R) {
        self.leftWidthRatio = leftWidthRatio
        self.leftContent = leftContent()
        self.rightContent = rightContent()
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: proxy.size.width * leftWidthRatio)
                    .overlay(leftContent)
                Color.clear
                    .overlay(rightContent)
            }
        }
    }
}

#Preview {
    SplitHStackDemoView()
}
