//
//  CalendarSideMenuReducer.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct CalendarSideMenuReducer {
	@ObservableState
	public struct State: Equatable, Sendable {
		public struct ViewState: Equatable, Sendable {
			public var title: String
			public var calendarGroups: [CalendarMenuGroup]
			public var checkedMenuItems: [CalendarMenuItem] {
				calendarGroups.flatMap { group in
					group.items.filter { $0.checked }
				}
			}

			public init(title: String = "", calendarGroups: [CalendarMenuGroup] = []) {
				self.title = title
				self.calendarGroups = calendarGroups
			}
		}
		
		public var viewState: ViewState = ViewState()

		public init() {}
		public init(viewState: ViewState) {
			self.viewState = viewState
		}
	}

	public enum Action: Equatable {
		case viewAction(ViewAction)
		case innerAction(InnerAction)

		public enum ViewAction: Equatable {
			case toggleGroup(CalendarMenuGroup)
			case toggleMenu(CalendarMenuItem)
		}

		public enum InnerAction: Equatable {
			case setTitle(String)
			case setCalendarGroups([CalendarMenuGroup])
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
			case .toggleGroup(let group):
				state.viewState.calendarGroups = state.viewState.calendarGroups.map { item in
					if item.id == group.id {
						return CalendarMenuGroup(id: item.id, name: item.name, items: item.items, isExpanded: !item.isExpanded)
					} else {
						return item
					}
				}
				return .none
			case .toggleMenu(let menu):
				state.viewState.calendarGroups = state.viewState.calendarGroups.map { group in
					var updatedGroup = group
					updatedGroup.items = toggledCalendars(group.items, for: menu.id)
					return updatedGroup
				}
				return .none
		}
	}

	func reduceInnerAction(_ innerAction: Action.InnerAction, state: inout State) -> Effect<Action> {
		switch innerAction {
			case .setTitle(let title):
				state.viewState.title = title
				return .none
			case .setCalendarGroups(let groups):
				state.viewState.calendarGroups = groups
				return .none
		}
	}
}

// MARK: - Methods
private extension CalendarSideMenuReducer {
	func toggledCalendars(_ calendars: [CalendarMenuItem], for id: UUID) -> [CalendarMenuItem] {
		calendars.map { item in
			if item.id == id {
				var updated = item
				updated.checked.toggle()
				return updated
			} else {
				return item
			}
		}
	}
}

// MARK: - Types
public struct CalendarMenuGroup: Identifiable, Equatable, Sendable {
	public let id: UUID
	public let name: String
	public var items: [CalendarMenuItem]
	public var isExpanded: Bool
	
	public init(id: UUID = UUID(), name: String, items: [CalendarMenuItem], isExpanded: Bool = false) {
		self.id = id
		self.name = name
		self.items = items
		self.isExpanded = isExpanded
	}
}

public struct CalendarMenuItem: Identifiable, Equatable, Sendable {
	public let id: UUID
	public let color: Color
	public let name: String
	public var checked: Bool
	
	public init(id: UUID = UUID(), color: Color, name: String, checked: Bool = false) {
		self.id = id
		self.color = color
		self.name = name
		self.checked = checked
	}
}
