//
//  GetSizeView.swift
//  GeometryReader
//
//  Created by pinch24 on 9/11/24.
//

import SwiftUI

struct GetSizeView: View {
    @State var width: CGFloat = .zero
    var body: some View {
        VStack {
            Text("Width = \(width)")
                .monospaced()
                .getWidth($width)
        }
    }
}

extension View {
    func getWidth(_ width: Binding<CGFloat>) -> some View {
        modifier(GetWidthModifier(width: width))
    }
}

struct GetWidthModifier: ViewModifier {
    @Binding var width: CGFloat
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    let proxyWidth = proxy.size.width
                    Color.clear
                        .task(id: proxy.size.width) {
                            $width.wrappedValue = max(proxyWidth, 0)
                        }
                })
    }
}

struct GetInfoByPreferenceKey: View {
    var body: some View {
        ScrollView {
            Text("Hello, World!")
                .overlay(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: MinYKey.self, value: proxy.frame(in: .global).minY)
                    }
                )
        }
        .onPreferenceChange(MinYKey.self) { value in
            print(value)
        }
    }
}

struct MinYKey: PreferenceKey {
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    static var defaultValue: CGFloat = .zero
}

#Preview {
    GetSizeView()
}
