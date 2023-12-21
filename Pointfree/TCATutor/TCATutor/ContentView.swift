//
//  ContentView.swift
//  TCATutor
//
//  Created by mk on 12/20/23.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
	let store: StoreOf<ContentFeature>
	
    var body: some View {
		TabView {
			CounterView(store: store.scope(state: \.tab1, action: \.tab1))
				.tabItem {
					Text("Counter 1")
				}
			
			CounterView(store: store.scope(state: \.tab2, action: \.tab2))
				.tabItem {
					Text("Counter 2")
				}
		}
    }
}

#Preview {
	ContentView(store: Store(initialState: ContentFeature.State(), reducer: {
		ContentFeature()
	}))
}
