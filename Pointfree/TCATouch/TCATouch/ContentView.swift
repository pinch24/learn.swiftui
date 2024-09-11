//
//  ContentView.swift
//  TCATouch
//
//  Created by mk on 12/26/23.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let counterStore: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text("The Composable Architecture")
            CounterView(store: counterStore)
        }
        .padding()
    }
}

#Preview {
    // ContentView()
    ContentView(counterStore: Store(initialState: CounterFeature.State(), reducer: {
        CounterFeature()
    }))
}
