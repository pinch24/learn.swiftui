//
//  GeometryReaderInScrollView.swift
//  GeometryReader
//
//  Created by pinch24 on 9/11/24.
//

import SwiftUI

struct GeometryReaderInScrollView: View {
    var body: some View {
        ScrollView {
            GeometryReader { _ in
                Rectangle()
                    .foregroundStyle(.orange)
            }
        }
    }
}

#Preview {
    GeometryReaderInScrollView()
}
