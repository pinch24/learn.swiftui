//
//  ContactsFeature.swift
//  TCANavigation
//
//  Created by MK on 3/16/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ContactsFeature {
	@ObservableState
	struct State: Equatable {
		@Presents var addContact: AddContactFeature.State?
		var contacts: IdentifiedArrayOf<Contact> = []
	}
	
	enum Action {
		case addButtonTapped
		case addContact(PresentationAction<AddContactFeature.Action>)
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .addButtonTapped:
				state.addContact = AddContactFeature.State(contact: Contact(id: UUID(), name: ""))
				return .none
			case .addContact(.presented(.delegate(.saveContact(let contact)))):
				state.contacts.append(contact)
				return .none
			case .addContact:
				return .none
			}
		}
		.ifLet(\.$addContact, action: \.addContact, destination: { AddContactFeature() })
	}
}

struct Contact: Equatable, Identifiable {
	let id: UUID
	var name: String
}

struct ContactsView: View {
	@Bindable var store: StoreOf<ContactsFeature>
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(store.contacts) { contact in
					Text(contact.name)
				}
				
			}
			.navigationTitle("Contacts")
			.toolbar {
				ToolbarItem {
					Button {
						store.send(.addButtonTapped)
					} label: {
						Image(systemName: "plus")
					}
				}
			}
		}
		.sheet(item: $store.scope(state: \.addContact, action: \.addContact)) { addContactStore in
			NavigationStack {
				AddContactView(store: addContactStore)
			}
		}
	}
}

#Preview {
	let store = Store(
		initialState: ContactsFeature.State(contacts: [
			Contact(id: UUID(), name: "Blob"),
			Contact(id: UUID(), name: "Blob Jr"),
			Contact(id: UUID(), name: "Blob Sr"),
		]),
		reducer: { ContactsFeature() }
	)
	
	ContactsView(store: store)
}
