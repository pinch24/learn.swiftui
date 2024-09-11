//
//  SizeView.swift
//  GeometryReader
//
//  Created by pinch24 on 9/11/24.
//

import SwiftUI

struct SizeView: View {
    var body: some View {
        Rectangle()
            .fill(Color.orange.gradient)
            .frame(width: 100, height: 100)
            .printViewSize()
            .scaleEffect(2.2)
    }
}

extension View {
    func printViewSize() -> some View {
        background(
            GeometryReader { proxy in
                let layoutSize = proxy.size
                let renderSize = proxy.frame(in: .global).size
                Color.clear
                    .task(id: layoutSize) {
                        print("Layout Size:", layoutSize)
                    }
                    .task(id: renderSize) {
                        print("RenderS Size:", renderSize)
                    }
            })
    }
}

#Preview {
    SizeView()
}
