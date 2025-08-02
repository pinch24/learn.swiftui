//
//  CalendarSideMenuView.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import SwiftUI
import ComposableArchitecture

public struct CalendarSideMenuView: View {
	private struct Constants {
		static let titleVPadding = CGFloat(10)
		static let groupVPadding = CGFloat(12)
		static let menuVPadding = CGFloat(14)
		static let menuHPadding = CGFloat(8)
		static let dividerVPadding = CGFloat(4)
		static let bulletSize = CGFloat(19)
	}
	
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
		VStack(alignment: .leading, spacing: .zero) {
			titleView(viewStore.title)
				.padding(.vertical, Constants.titleVPadding)
			
			// 각 캘린더 그룹
			ForEach(viewStore.calendarGroups, id: \.name) { group in
				calendarGroupView(group)
				if group.name != viewStore.calendarGroups.last?.name {
					Divider()
						.padding(.vertical, Constants.dividerVPadding)
				}
			}
		}
		.frame(maxHeight: .infinity, alignment: .top)
		.background(Color.gray.opacity(0.1))
		.padding(.horizontal)
	}
	
	private func titleView(_ title: String) -> some View {
		HStack {
			Text(title)
				.font(.largeTitle.bold())
				.foregroundStyle(Color.primary)
			Spacer()
		}
	}
	
	private func calendarGroupView(_ group: CalendarMenuGroup) -> some View {
		VStack(alignment: .leading, spacing: .zero) {
			Button {
				viewStore.send(.toggleGroup(group), animation: .easeInOut)
			} label: {
				Text(group.name)
					.font(.headline.weight(.semibold))
					.foregroundStyle(Color.primary)
					.padding(.vertical, Constants.groupVPadding)
				Spacer()
				Image(systemName: group.isExpanded ? "chevron.up" : "chevron.down")
					.renderingMode(.template)
					.foregroundStyle(Color.gray)
			}
			.buttonStyle(.plain)
			
			if group.isExpanded {
				VStack(alignment: .leading, spacing: .zero) {
					ForEach(group.items) { item in
						Button {
							viewStore.send(.toggleMenu(item))
						} label: {
							if item.checked {
								Image(systemName: "checkmark.square.fill")
									.renderingMode(.template)
									.foregroundStyle(item.color)
							} else {
								Image(systemName: "circle")
									.resizable()
									.frame(width: Constants.bulletSize, height: Constants.bulletSize)
							}
							Text(item.name)
								.font(.subheadline)
								.foregroundStyle(Color.primary)
						}
						.padding(.leading, Constants.menuHPadding)
						.padding(.vertical, Constants.menuVPadding)
					}
				}
				.transition(.opacity)
			}
		}
	}
}

#if DEBUG
#Preview {
	CalendarSideMenuPreview()
}

struct CalendarSideMenuPreview: View {
	private let store = Store(
		initialState: CalendarSideMenuReducer.State(
			viewState: .init(
				title: "내 캘린더",
				calendarGroups: CalendarSideMenuPreview.getCalendarMenu()
			)
		),
		reducer: { CalendarSideMenuReducer() }
	)
	var body: some View {
		CalendarSideMenuView(store: store)
	}
	
	static func getCalendarMenu() -> [CalendarMenuGroup] {
		[
			CalendarMenuGroup(
				name: "내 캘린더",
				items: [
					CalendarMenuItem(color: Color.mint, name: "김두레", checked: false),
					CalendarMenuItem(color: Color.blue, name: "[공유] 프로덕트디자인1팀", checked: true),
					CalendarMenuItem(color: Color.cyan, name: "[공유] D-TF", checked: true)
				],
				isExpanded: true
			),
			CalendarMenuGroup(
				name: "공유 캘린더",
				items: [
					CalendarMenuItem(color: Color.red, name: "대한민국 휴일", checked: true)
				],
				isExpanded: true
			),
			CalendarMenuGroup(
				name: "프로젝트",
				items: [
					CalendarMenuItem(color: Color.orange, name: "Dooray!", checked: true),
					CalendarMenuItem(color: Color.purple, name: "DApp TF", checked: false),
					CalendarMenuItem(color: Color.brown, name: "NHN 디자인실", checked: true),
					CalendarMenuItem(color: Color.indigo, name: "리뉴얼-NHN 홈페이지", checked: false),
					CalendarMenuItem(color: Color.green, name: "Waplat-Project", checked: true)
				],
				isExpanded: true
			)
		]
	}

}
#endif
