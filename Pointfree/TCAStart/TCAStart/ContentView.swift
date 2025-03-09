//
//  ContentView.swift
//  TCAStart
//
//  Created by Mk on 3/9/25.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
	let store = Store(initialState: CounterFeature.State(), reducer: { CounterFeature() })
	
    var body: some View {
		CounterView(store: store)
    }
}

#Preview {
    ContentView()
}
