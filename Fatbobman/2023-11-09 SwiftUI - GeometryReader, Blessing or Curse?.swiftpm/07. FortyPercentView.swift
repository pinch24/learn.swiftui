//
//  FortyPercentView.swift
//  GeometryReader
//
//  Created by pinch24 on 9/11/24.
//

import SwiftUI

struct FortyPercentView: View {
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                ForEach(0 ..< 5) { _ in
                    Color.clear.frame(maxHeight: 0)
                }
            }
            GridRow {
                AsyncImage(url: URL(string: "https://picsum.photos/400/200")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .gridCellColumns(2)
                    } else if phase.error != nil {
                        Text("Image Loading Error!")
                    } else {
                        ProgressView()
                    }
                }
                Text("Switf Weekly")
                    .font(.title)
                    .gridCellColumns(3)
            }
        }
        .border(.blue)
        .padding()
    }
}

#Preview {
    FortyPercentView()
}
