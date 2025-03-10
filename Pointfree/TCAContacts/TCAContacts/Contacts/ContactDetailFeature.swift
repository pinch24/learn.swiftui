//
//  ContactDetailFeature.swift
//  TCAContacts
//
//  Created by Mk on 3/10/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ContactDetailFeature {
	@ObservableState
	struct State: Equatable {
		let contact: Contact
	}
	
	enum Action {
		
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				  
			}
		}
	}
}

struct ContactDetailView: View {
	let store: StoreOf<ContactDetailFeature>
	
	var body: some View {
		Form {
			
		}
		.navigationTitle(Text(store.contact.name))
	}
}

#Preview {
	NavigationStack {
		ContactDetailView(
			store: Store(
				initialState: ContactDetailFeature.State(contact: Contact(id: UUID(), name: "Blob")),
				reducer: { ContactDetailFeature() }
			)
		)
	}
}
