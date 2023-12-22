//
//  ContactDetailFeature.swift
//  TCATutor
//
//  Created by mk on 12/22/23.
//

import ComposableArchitecture

@Reducer
struct ContactDetailFeature {
	struct State: Equatable {
		let contact: Contact
		@PresentationState var alert: AlertState<Action.Alert>?
	}
	
	enum Action {
		case alert(PresentationAction<Alert>)
		case delegate(Delegate)
		case delegateButtonTapped
		
		enum Alert {
			case confirmDeletion
		}
		
		enum Delegate {
			case confirmDeletion
		}
	}
	
	@Dependency(\.dismiss) var dismiss
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .alert(.presented(.confirmDeletion)):
				return .run { send in
					await send(.delegate(.confirmDeletion))
					await self.dismiss()
				}
			case .alert:
				return .none
			case .delegate:
				return .none
			case .delegateButtonTapped:
				state.alert = .confirmDeletion
				return .none
			}
		}
		.ifLet(\.$alert, action: \.alert)
	}
}

extension AlertState where Action == ContactDetailFeature.Action.Alert {
	static let confirmDeletion = Self {
		TextState("Are you sure?")
	} actions: {
		ButtonState(role: .destructive, action: .confirmDeletion) {
			TextState("Delete")
		}
	}
}