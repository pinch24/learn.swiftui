//
//  ImageContainerView.swift
//  GeometryReader
//
//  Created by pinch24 on 9/11/24.
//

import SwiftUI

struct ImageContainerView: View {
    var body: some View {
        ImageContainer(imageName: "https://picsum.photos/400/200")
    }
}

struct ImageContainer: View {
    @State private var width: CGFloat = .zero
    let imageName: String
    var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: URL(string: imageName)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .task(id: proxy.size.width) {
                            width = max(proxy.size.width, 0)
                        }
                } else if phase.error != nil {
                    Text("Image Loading Error!")
                } else {
                    ProgressView()
                }
            }
        }
        .frame(height: width / 1.77)
        .clipped()
    }
}

#Preview {
    ImageContainerView()
}
