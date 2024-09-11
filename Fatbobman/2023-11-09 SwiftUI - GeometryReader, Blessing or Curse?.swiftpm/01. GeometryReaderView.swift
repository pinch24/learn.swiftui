//
//  GeometryReaderView.swift
//  GeometryReaderView
//
//  Created by pinch24 on 9/11/24.
//

import SwiftUI

struct GeometryReaderView: View {
    var body: some View {
        // GeometryReader View
        GeometryReader { _ in
            Rectangle()
                .frame(width: 50, height: 50)
            Text("abc")
                .foregroundStyle(.white)
        }
        
        // Convert GeometryReader View to ZStack View
        ZStack(alignment: .topLeading) {
            Rectangle().frame(width: 50, height: 50)
            Text("abc").foregroundStyle(.white)
        }
        .frame(
            idealWidth: 10,
            maxWidth: .infinity,
            idealHeight: 10,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}

#Preview {
    GeometryReaderView()
}
