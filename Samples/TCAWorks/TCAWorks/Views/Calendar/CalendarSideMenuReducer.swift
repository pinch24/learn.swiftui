//
//  CalendarSideMenuReducer.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import ComposableArchitecture

@Reducer
public struct CalendarSideMenuReducer {
	@ObservableState
	public struct State: Equatable, Sendable {
		public struct ViewState: Equatable, Sendable {
			public var title: String = "Hello, detail!"
		}

		public init() {}

		public var viewState: ViewState = ViewState()
	}

	public enum Action: Equatable {
		case viewAction(ViewAction)
		case innerAction(InnerAction)

		public enum ViewAction: Equatable {
			case sendAction
		}

		public enum InnerAction: Equatable {
			case setTitle(String)
		}
	}
	
	public init() {}
	
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case .viewAction(let viewAction):
					return reduceViewAction(viewAction, state: &state)
				case .innerAction(let innerAction):
					return reduceInnerAction(innerAction, state: &state)
			}
		}
	}
}

// MARK: - Actions
extension CalendarSideMenuReducer {
	func reduceViewAction(_ viewAction: Action.ViewAction, state: inout State) -> Effect<Action> {
		switch viewAction {
			case .sendAction:
				return .none
		}
	}

	func reduceInnerAction(_ innerAction: Action.InnerAction, state: inout State) -> Effect<Action> {
		switch innerAction {
			case .setTitle(let title):
				state.viewState.title = title
				return .none
		}
	}
}
