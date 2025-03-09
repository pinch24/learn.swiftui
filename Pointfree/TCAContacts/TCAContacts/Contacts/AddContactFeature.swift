//
//  AddContactFeature.swift
//  TCAContacts
//
//  Created by Mk on 3/9/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AddContactFeature {
	@ObservableState
	struct State: Equatable {
		var contact: Contact
	}
	
	enum Action {
		case cancelButtonTapped
		case delegate(Delegate)
		case saveButtonTapped
		case setName(String)
		@CasePathable
		enum Delegate: Equatable {
			
			case saveContact(Contact)
		}
	}
	
	@Dependency(\.dismiss) var dismiss
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .cancelButtonTapped:
				return .run { _ in await self.dismiss() }
				
			case .delegate:
				return .none
				
			case .saveButtonTapped:
				return .run { [contact = state.contact] send in
					await send(.delegate(.saveContact(contact)))
					await self.dismiss()
				}
				
			case .setName(let name):
				state.contact.name = name
				return .none
			}
		}
	}
}

struct AddContactView: View {
	@Bindable var store: StoreOf<AddContactFeature>
	
	var body: some View {
		Form {
			TextField("Name", text: $store.contact.name.sending(\.setName))
			Button("Save") {
				store.send(.saveButtonTapped)
			}
		}
		.toolbar {
			ToolbarItem {
				Button("Cancel") {
					store.send(.cancelButtonTapped)
				}
			}
		}
	}
}

#Preview {
	let store = Store(initialState: AddContactFeature.State(contact: Contact(id: UUID(), name: "")), reducer: { AddContactFeature() })
	AddContactView(store: store)
}
