//
//  VisualEffectView.swift
//  GeometryReader
//
//  Created by pinch24 on 9/11/24.
//

import SwiftUI

@available(iOS 17.0, *)
struct VisualEffectView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .visualEffect { content, geometryProxy in
                content.offset(x: geometryProxy.frame(in: .global).origin.y)
            }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        VisualEffectView()
    } else {
        // Fallback on earlier versions
    }
}
