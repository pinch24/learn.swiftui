//
//  AppView.swift
//  TCAStart
//
//  Created by Mk on 3/9/25.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
	let store: StoreOf<AppFeature>
	
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
	let store = Store(initialState: AppFeature.State(), reducer: { AppFeature() })
	AppView(store: store)
}
