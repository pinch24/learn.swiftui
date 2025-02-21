//
//  ContentView.swift
//  RippleVisualEffect
//
//  Created by Meng To on 18/6/24.
//

import SwiftUI

struct ContentView: View {
    @State var counter: Int = 0
    @State var origin: CGPoint = .init(x: 0.5, y: 0.5)
    
    var body: some View {
        VStack {
            Text("Ripple Effect")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .foregroundColor(.white)
        .background(.blue)
        .cornerRadius(30)
        .onPressingChanged { point in
            if let point {
                origin = point
                counter += 1
            }
        }
        .modifier(RippleEffect(at: origin, trigger: counter))
        .padding()
    }
}

#Preview {
    ContentView()
}
