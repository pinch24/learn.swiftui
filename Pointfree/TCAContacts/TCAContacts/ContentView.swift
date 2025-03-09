//
//  ContentView.swift
//  TCAContacts
//
//  Created by Mk on 3/9/25.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
	var body: some View {
		let store = Store(
			initialState: ContactsFeature.State(
				contacts: [
					Contact(id: UUID(), name: "Blob"),
					Contact(id: UUID(), name: "Blob Jr"),
					Contact(id: UUID(), name: "Blob Sr"),
				]
			),
			reducer: { ContactsFeature() })
        ContactsView(store: store)
    }
}

#Preview {
	ContentView()
}
