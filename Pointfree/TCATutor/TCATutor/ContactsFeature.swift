//
//  ContactsFeature.swift
//  TCATutor
//
//  Created by mk on 12/21/23.
//

import Foundation
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
	let id: UUID
	var name: String
}

@Reducer
struct ContactsFeature {
	struct State: Equatable {
		var contacts: IdentifiedArrayOf<Contact> = []
		@PresentationState var destination: Destination.State?
	}
	
	enum Action {
		case addButtonTapped
		case deleteButtonTapped(id: Contact.ID)
		case destination(PresentationAction<Destination.Action>)
		
		enum Alert: Equatable {
			case confirmDeletion(id: Contact.ID)
		}
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .addButtonTapped:
				state.destination = .addContact(
					AddContactFeature.State(contact: Contact(id: UUID(), name: "")))
				return .none
				
			case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
				state.contacts.append(contact)
				return .none
				
			case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
				state.contacts.remove(id: id)
				return .none
				
			case .destination:
				return .none
				
			case let .deleteButtonTapped(id: id):
				state.destination = .alert(
					AlertState {
						TextState("Are you sure?")
					} actions: {
						ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
							TextState("Delete")
						}
					}
				)
				return .none
			}
		}
		.ifLet(\.$destination, action: \.destination) {
			Destination()
		}
	}
}

extension ContactsFeature {
	@Reducer
	struct Destination {
		enum State: Equatable {
			case addContact(AddContactFeature.State)
			case alert(AlertState<ContactsFeature.Action.Alert>)
		}
		
		enum Action {
			case addContact(AddContactFeature.Action)
			case alert(ContactsFeature.Action.Alert)
		}
		
		var body: some ReducerOf<Self> {
			Scope(state: \.addContact, action: \.addContact) {
				AddContactFeature()
			}
		}
	}
}
