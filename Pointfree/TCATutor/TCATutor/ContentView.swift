//
//  ContentView.swift
//  TCATutor
//
//  Created by mk on 12/20/23.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
	let counterStore: StoreOf<ContentFeature>
	let contactsStore: StoreOf<ContactsFeature>
	
    var body: some View {
		TabView {
			CounterView(store: counterStore.scope(state: \.tab1, action: \.tab1))
				.tabItem {
					Text("Counter 1")
				}
			
			CounterView(store: counterStore.scope(state: \.tab2, action: \.tab2))
				.tabItem {
					Text("Counter 2")
				}
			ContactsView(store: contactsStore)
				.tabItem {
					Text("Contacts")
				}
		}
    }
}

#Preview {
	ContentView(
		counterStore: Store(initialState: ContentFeature.State(), reducer: {
			ContentFeature()
		}),
		contactsStore: Store(initialState: ContactsFeature.State(), reducer: {
			ContactsFeature()
		}))
}
