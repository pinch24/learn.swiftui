//
//  CalendarSideMenuView.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import ComposableArchitecture
import SwiftUI

public struct CalendarSideMenuView: View {
	public var id: UUID = UUID()
	
	typealias ViewState = CalendarSideMenuReducer.State.ViewState
	typealias ViewAction = CalendarSideMenuReducer.Action.ViewAction

	init(store: StoreOf<CalendarSideMenuReducer>) {
		self.store = store
		self.viewStore = ViewStore(
			store,
			observe: { $0.viewState },
			send: { .viewAction($0) }
		)
	}

	private let store: StoreOf<CalendarSideMenuReducer>
	@ObservedObject private var viewStore: ViewStore<ViewState, ViewAction>

	public var body: some View {
		VStack {
			Text("CalendarSideMenuView")
			HStack {
				Button("Send Action") {
					viewStore.send(.sendAction)
				}
				.padding(4)
				.border(.blue)
			}
			.padding(20)
			
		}
		.background(Color.white)
	}
}

#Preview {
	CalendarSideMenuView(
		store: Store(
			initialState: CalendarSideMenuReducer.State(),
			reducer: {
				CalendarSideMenuReducer()
			}
		)
	)
}
