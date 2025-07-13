//
//  MoreServiceEditReducer.swift
//  TCAWorks
//
//  Created by MK on 7/13/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct MoreServiceEditReducer {
	@ObservableState
	public struct State: Equatable, Sendable {
		public struct ViewState: Equatable, Sendable {
			public var menuSections: [ServiceMenuSection]
			public var count = 0
			
			public init(
				menuSections: [ServiceMenuSection] = []
			) {
				self.menuSections = menuSections
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
		case changeAction(ChangeAction)
		case delegateAction(DelegateAction)

		public enum ViewAction: Equatable {
			case onAppear
			case updateMenuSection(sectionId: UUID, menuItems: [ServiceMenuItem])
			case dismiss
		}
		
		public enum ChangeAction: Equatable {
			case setMenuSections([ServiceMenuSection])
		}
		
		public enum DelegateAction: Equatable {
			case dismiss
		}
	}
	
	public init() {}
	
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case .viewAction(let viewAction):
					return reduceViewAction(viewAction, state: &state)
				case .changeAction(let changeAction):
					return reduceChangeAction(changeAction, state: &state)
				case .delegateAction(let delegateAction):
					return reduceDelegateAction(delegateAction, state: &state)
			}
		}
	}
}

// MARK: - Actions
extension MoreServiceEditReducer {
	func reduceViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
		switch action {
			case .onAppear:
				let menuSections = mockData()
				state.viewState.count += 1
				return .send(.changeAction(.setMenuSections(menuSections)))
				
			case .updateMenuSection(let sectionId, let menuItems):
				print("📝 Update Menu Section: \(sectionId), Items: \(menuItems.count)")
				if let index = state.viewState.menuSections.firstIndex(where: { $0.id == sectionId }) {
					state.viewState.menuSections[index].menuItems = menuItems
				}
				return .none
				
			case .dismiss:
				return .send(.delegateAction(.dismiss))
		}
	}
	
	func reduceChangeAction(_ action: Action.ChangeAction, state: inout State) -> Effect<Action> {
		switch action {
			case .setMenuSections(let sections):
				state.viewState.menuSections = sections
				return .none
		}
	}
	
	func reduceDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
		switch action {
			case .dismiss:
				return .none
		}
	}
}

// MARK: - Types
public struct ServiceMenuItem: Identifiable, Equatable, Sendable {
	public let id: UUID
	public let title: String
	public let image: Image?
	public var order: Int
	
	public init(id: UUID = UUID(), title: String, image: Image? = nil, order: Int = 0) {
		self.id = id
		self.title = title
		self.image = image
		self.order = order
	}
}

public struct ServiceMenuSection: Identifiable, Equatable, Sendable {
	public let id: UUID
	public let title: String
	public var menuItems: [ServiceMenuItem]
	
	public var nextOrder: Int {
		let lastOrderValue = menuItems.map { $0.order }.max() ?? 0
		return lastOrderValue + 1
	}
	
	public init(id: UUID = UUID(), title: String, menuItems: [ServiceMenuItem] = []) {
		self.id = id
		self.title = title
		self.menuItems = menuItems
	}
}

// TODO: 테스트 데이터
extension MoreServiceEditReducer {
	func mockData() -> [ServiceMenuSection] {
		var menuSection: [ServiceMenuSection] = []
		
		let tabBarSection = ServiceMenuSection(
			title: "하단 메뉴 순서",
			menuItems: [
				ServiceMenuItem(title: "메일", image: Image(systemName: "envelope")),
				ServiceMenuItem(title: "메신저", image: Image(systemName: "message")),
				ServiceMenuItem(title: "업무", image: Image(systemName: "checkmark.circle")),
				ServiceMenuItem(title: "캘린더", image: Image(systemName: "calendar"))
			]
		)
		menuSection.append(tabBarSection)
		
		let moreMenuSection = ServiceMenuSection(
			title: "더보기",
			menuItems: [
				ServiceMenuItem(title: "드라이브", image: Image(systemName: "cloud")),
				ServiceMenuItem(title: "위키", image: Image(systemName: "book")),
				ServiceMenuItem(title: "결재", image: Image(systemName: "signature")),
				ServiceMenuItem(title: "사내게시판", image: Image(systemName: "list.bullet")),
				ServiceMenuItem(title: "조직도", image: Image(systemName: "person.3"))
			]
		)
		menuSection.append(moreMenuSection)
		
		return menuSection
	}
}
