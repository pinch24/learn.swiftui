//
//  AddContactFeature.swift
//  TCANavigation
//
//  Created by MK on 3/22/25.
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
		case saveButtonTapped
		case setName(String)
		case delegate(Delegate)
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
			case .saveButtonTapped:
				return .run { [contact = state.contact] send in
					await send(.delegate(.saveContact(contact)))
					await self.dismiss()
				}
			case .setName(let name):
				state.contact.name = name
				return .none
			case .delegate:
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
	NavigationStack {
		AddContactView(
			store: Store(
				initialState: AddContactFeature.State(contact: Contact(id: UUID(), name: "Blob")),
				reducer: { AddContactFeature() })
		)
	}
}
