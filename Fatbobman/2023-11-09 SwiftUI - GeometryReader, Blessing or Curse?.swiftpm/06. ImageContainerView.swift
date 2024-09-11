//
//  ImageContainer2View.swift
//  GeometryReader
//
//  Created by pinch24 on 9/11/24.
//

import SwiftUI

struct ImageContainer2View: View {
    var body: some View {
        ScrollView {
            ImageContainer2(imageName: "https://picsum.photos/400/200")
        }
    }
}

struct ImageContainer2: View {
    @State private var width: CGFloat = .zero
    let imageName: String
    var body: some View {
        Color.clear
            .aspectRatio(1.77, contentMode: .fill)
            .overlay(alignment: .topLeading) {
                AsyncImage(url: URL(string: imageName)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        Text("Image Loading Error!")
                    } else {
                        ProgressView()
                    }
                }
            }
            .clipped()
    }
}

#Preview {
    ImageContainer2View()
}
