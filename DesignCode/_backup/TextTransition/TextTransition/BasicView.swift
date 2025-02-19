//
//  BasicView.swift
//  TextTransition
//
//  Created by Meng To on 15/6/24.
//

import SwiftUI

struct BasicView: View {
    @State var isVisible = true
    
    var body: some View {
        VStack {
            if isVisible {
                Text("Text Transition")
                    .customAttribute(EmphasisAttribute())
                    .foregroundStyle(.primary)
                    .font(.system(size: 44, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .transition(TextTransition())
            }
            Button("Toggle Visibility") {
                isVisible.toggle()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
        }
        .padding(40)
    }
}

#Preview {
    BasicView()
}
