//
//  ContentView.swift
//  TCAEssential
//
//  Created by MK on 3/16/25.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
	//static let store = Store(initialState: CounterFeature.State(), reducer: { CounterFeature() })
	static let store = Store(initialState: AppFeature.State(), reducer: { AppFeature() })
	
    var body: some View {
		//CounterView(store: Self.store)
		AppView(store: Self.store)
    }
}

#Preview {
	ContentView()
}
