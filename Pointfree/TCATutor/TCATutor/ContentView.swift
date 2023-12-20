//
//  ContentView.swift
//  TCATutor
//
//  Created by mk on 12/20/23.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
	static let store = Store(initialState: CounterFeature.State()) {
		CounterFeature()
			._printChanges()
	}
	
    var body: some View {
        VStack {
			CounterView(store: Self.store)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
