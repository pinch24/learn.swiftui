//
//  CalendarMainReducer.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct CalendarMainReducer {
	@ObservableState
	public struct State: Equatable, Sendable {
		public struct ViewState: Equatable, Sendable {
			public var mode: CalendarMode = .month
			public var events: [CalendarEvent] = []
			public var selectedDateValue: Int = 0
		}

		public var viewState: ViewState = .init()
		public var sideMenuState: CalendarSideMenuReducer.State = .init()
		
		public init() {}
		public init(events: [CalendarEvent], selectedDateValue: Int = 0) {
			self.viewState.events = events
			self.viewState.selectedDateValue = selectedDateValue
		}
	}
	
	public enum Action: Equatable {
		public enum ViewAction: Equatable {
			case setEvents([CalendarEvent])
			case setSelectedDate(Int)
		}
		
		case viewAction(ViewAction)
		case sideMenuAction(CalendarSideMenuReducer.Action)
	}
	
	public init() {}
	
	public var body: some ReducerOf<Self> {
		Scope(
			state: \.sideMenuState,
			action: \.sideMenuAction,
			child: { CalendarSideMenuReducer() }
		)
		
		Reduce { state, action in
			switch action {
				case .viewAction(let viewAction):
					return reduceViewAction(viewAction, state: &state)
				case .sideMenuAction(let action):
					return reducerSideMenuAction(action, state: &state)
			}
		}
	}
}

// MARK: - Actions
extension CalendarMainReducer {
	func reduceViewAction(_ viewAction: Action.ViewAction, state: inout State) -> Effect<Action> {
		switch viewAction {
			case .setEvents(let events):
				state.viewState.events = events
				return .none
			case .setSelectedDate(let value):
				state.viewState.selectedDateValue = value
				return .none
		}
	}
	
	func reducerSideMenuAction(_ action: CalendarSideMenuReducer.Action, state: inout State) -> Effect<Action> {
		switch action {
			case .viewAction(.sendAction):
				print("action - \(action)")
				return .none
			default:
				return .none
		}
	}
}
