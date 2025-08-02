//
//  CalendarMainReducer.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct CalendarMainReducer : Sendable{
	@ObservableState
	public struct State: Equatable {
		public var mode: CalendarMode = .month
		public var events: [CalendarEvent]
		public var daysList: [String: [[CalendarDay]]]
		public var visibleEvents: [String: [CalendarEvent]]
		
		// 월간 캘린더 프로퍼티
		public var weekRange: Int = 7
		public var selectedMonth: String
		public var prevMonth: String {
			let date = Date.from(selectedMonth, format: "yyyy.MM")
			let prevDate = Calendar.current.date(byAdding: .month, value: -1, to: date)!
			return prevDate.yearMonth
		}
		public var nextMonth: String {
			let date = Date.from(selectedMonth, format: "yyyy.MM")
			let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: date)!
			return nextDate.yearMonth
		}
		
		// 일간 캘린더 프로퍼티
		public var selectedDay: String?
		
		// 플로팅 버튼
		public var isScrollFloatingNew = false
		public var isScrollFloatingToday = false
		
		// 사이드 메뉴
		public var isShowSideMenu = false
		public var isShowTaskMode = false  // 담당 업무 표시 여부
		
		public var menuState: CalendarSideMenuReducer.State
		
		public init(events: [CalendarEvent] = [], daysInMonth: [String: [[CalendarDay]]] = [:], visibleEnents: [String: [CalendarEvent]] = [:], selectedMonth: String = "", menuState: CalendarSideMenuReducer.State = .init()) {
			self.events = events
			self.daysList = daysInMonth
			self.visibleEvents = visibleEnents
			self.selectedMonth = selectedMonth
			self.menuState = menuState
		}
	}
	
	public enum Action: Equatable {
		case viewAction(ViewAction)
		case changeAction(ChangeAction)
		case menuAction(CalendarSideMenuReducer.Action)
		
		public enum ViewAction: Equatable {
			case onAppear(String)
			// Calendar Paging UI
			case setSelectedMonth(String)
			case setSelectedDay(String?)
			case setDaysList(String)
			case setVisibleEvents(String)
			// Floating Menu
			case setFloatingMenuScrollNew(Bool)
			case setFloatingMenuScrollToday(Bool)
			// Side Menu
			case setShowSideMenu(Bool)
		}
		
		public enum ChangeAction: Equatable {
			case updateSelectedMonth(String)
			case updateDaysList(String, [[CalendarDay]])
			case updateVisibleEvents([String: [CalendarEvent]])
			case removeAllData
			case updateSelectedDay(String?)
			case updateFloatingMenuScrollNew(Bool)
			case updateFloatingMenuScrollToday(Bool)
			case updateShowSideMenu(Bool)
			case updateMode(CalendarMode)
			case updateTaskMode(Bool)
			// 캘린더 데이터 주입
			case updateMenus(String, [CalendarMenuGroup])
			case updateEvents([CalendarEvent])
		}
	}
	
	public init() {}
	
	public var body: some ReducerOf<Self> {
		Scope(state: \.menuState, action: \.menuAction) {
			CalendarSideMenuReducer()
		}
		
		Reduce { state, action in
			switch action {
				case .viewAction(let action):
					return reduceViewAction(action, state: &state)
				case .changeAction(let action):
					return reduceChangeAction(action, state: &state)
				case .menuAction(let action):
					switch action {
						case .viewAction(.toggleMenu(_)):
							let month = state.selectedMonth
							return .concatenate([
								.send(.changeAction(.removeAllData)),
								.send(.viewAction(.setDaysList(month))),
								.send(.viewAction(.setVisibleEvents(month)))
							])
						default:
							return .none
					}
			}
		}
	}
}

// MARK: - Actions
extension CalendarMainReducer {
	func reduceViewAction(_ viewAction: Action.ViewAction, state: inout State) -> Effect<Action> {
		switch viewAction {
			case .onAppear(let month):
				return .run { send in
					await send(.changeAction(.updateSelectedMonth(month)))
					await send(.viewAction(.setDaysList(month)))
					await send(.viewAction(.setVisibleEvents(month)))
				}
			// Calendar Grid
			case .setSelectedMonth(let month):
				return .concatenate([
					.send(.changeAction(.updateSelectedMonth(month))),
					.send(.viewAction(.setDaysList(month))),
					.send(.viewAction(.setVisibleEvents(month)))
				])
			case .setSelectedDay(let string):
				return .send(.changeAction(.updateSelectedDay(string)))
			case .setDaysList(let month):
				guard state.daysList.keys.contains(month) == false else { return .none }
				let days = generateDaysList(month: month, weekRange: state.weekRange)
				return .send(.changeAction(.updateDaysList(month, days)))
			case .setVisibleEvents(let month):
				guard let days = state.daysList[month] else { return .none }
				let events = state.events
				let checkedMenuItems = state.menuState.viewState.checkedMenuItems
				var visibleEvents = state.visibleEvents
				for day in days.flatMap({ $0 }) {
					let visibleEventList = makeVisibleEvents(day: day,
															 events: events,
															 categories: checkedMenuItems,
															 visibleEvents: visibleEvents,
															 weekRange: state.weekRange)
					visibleEvents[day.date.yearMonthDay] = visibleEventList
				}
				return .send(.changeAction(.updateVisibleEvents(visibleEvents)))
			// Floating Menu
			case .setFloatingMenuScrollNew(let isScroll):
				return .send(.changeAction(.updateFloatingMenuScrollNew(isScroll)))
			case .setFloatingMenuScrollToday(let isScroll):
				return .send(.changeAction(.updateFloatingMenuScrollToday(isScroll)))
			// Side Menu
			case .setShowSideMenu(let show):
				return .send(.changeAction(.updateShowSideMenu(show)))
		}
	}
	
	func reduceChangeAction(_ changeAction: Action.ChangeAction, state: inout State) -> Effect<Action> {
		switch changeAction {
			// 캘린더 그리드
			case .updateSelectedMonth(let month):
				state.selectedMonth = month
				return .none
			case .updateDaysList(let month, let daysList):
				state.daysList[month] = daysList
				return .none
			case .updateVisibleEvents(let visibleEvents):
				state.visibleEvents = visibleEvents
				return .none
			case .removeAllData:
				state.daysList.removeAll()
				state.visibleEvents.removeAll()
				return .none
			case .updateSelectedDay(let day):
				state.selectedDay = day
				return .none
			// 프로팅 버튼 스크롤
			case .updateFloatingMenuScrollNew(let isScroll):
				state.isScrollFloatingNew = isScroll
				return .none
			case .updateFloatingMenuScrollToday(let isScroll):
				state.isScrollFloatingToday = isScroll
				return .none
			// 사이드 메뉴
			case .updateShowSideMenu(let show):
				state.isShowSideMenu = show
				return .none
			case .updateMode(let mode):
				state.mode = mode
				return .none
			case .updateTaskMode(let isOn):
				state.isShowTaskMode = isOn
				return .none
			// 캘린더 데이터 주입
			case .updateMenus(let title, let menus):
				state.menuState.viewState.title = title
				state.menuState.viewState.calendarGroups = menus
				return .none
			case .updateEvents(let events):
				state.events = events
				return .none
		}
	}
}

extension CalendarMainReducer {
	private func generateDaysList(month: String, weekRange: Int) -> [[CalendarDay]] {
		// 이번 달 날짜 생성
		let date = Date.from(month, format: "yyyy.MM")
		let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
		let range = Calendar.current.range(of: .day, in: .month, for: startOfMonth)!
		let days = range.map { day -> CalendarDay in
			let dayDate = Calendar.current.date(byAdding: .day, value: day - 1, to: startOfMonth)!
			return CalendarDay(date: dayDate, day: day, isInMonth: true)
		}
		
		// 이전 달 날짜 생성
		let firstWeekday = Calendar.current.component(.weekday, from: startOfMonth) - Calendar.current.firstWeekday
		let leadingEmptyDays = (firstWeekday + weekRange) % weekRange
		let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: startOfMonth)!
		let previousMonthRange = Calendar.current.range(of: .day, in: .month, for: previousMonth)!
		var leadingDays: [CalendarDay] = []
		if leadingEmptyDays > 0 {
			let trailingDaysStart = previousMonthRange.count - leadingEmptyDays + 1
			leadingDays = (trailingDaysStart...previousMonthRange.count).map { day in
				let dayDate = Calendar.current.date(byAdding: .day, value: day - 1, to: previousMonth)!
				return CalendarDay(date: dayDate, day: day, isInMonth: false)
			}
		}
		
		var paddedDays: [CalendarDay] = leadingDays + days
		
		// 다음 달 날짜 생성
		let totalCount = paddedDays.count
		let rows = Int(ceil(Double(totalCount) / Double(weekRange)))
		let needed = rows * weekRange
		let remaining = needed - totalCount
		
		if remaining > 0 {
			let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth)!
			let nextMonthDays: [CalendarDay] = (1...remaining).map { offset -> CalendarDay in
				let dayDate = Calendar.current.date(byAdding: .day, value: offset - 1, to: nextMonth)!
				return CalendarDay(date: dayDate, day: offset, isInMonth: false)
			}
			paddedDays += nextMonthDays
		}
		
		// 생성된 날짜 데이터 저장
		let daysList = stride(from: 0, to: paddedDays.count, by: weekRange).map { Array(paddedDays[$0..<$0.advanced(by: weekRange)]) }
		return daysList
	}
	
	private func makeVisibleEvents(day: CalendarDay, events: [CalendarEvent], categories: [CalendarMenuItem], visibleEvents: [String: [CalendarEvent]], weekRange: Int) -> [CalendarEvent] {
		// 날짜에 해당하는 캘린더 셀에 표시할 이벤트만 필터링
		let events = events.filter { event in
			let startDate = Calendar.current.startOfDay(for: event.date)
			let endDate = Calendar.current.startOfDay(for: (event.endDate ?? event.date))
			let limitDate = Calendar.current.date(byAdding: DateComponents(day: 1), to: endDate)!
			return startDate <= day.date && day.date < limitDate
		}
		
		// 사이드 메뉴 필터 처리
		let filteredEvents = events.filter { event in
			return categories.contains(where: { $0.name == event.category })
		}
		
		// 이벤트가 위치할 행
		var rows: Set<Int> = []
		
		// 현재 날짜에 표시되는 연속 이벤트 우선 지정
		for event in filteredEvents {
			if let endDate = event.endDate,
			   !Calendar.current.isDate(event.date, inSameDayAs: endDate) {
				// 연속 이벤트인 경우, 다른 날짜에서 이미 할당된 행이 있는지 확인
				let prevDayDate = Calendar.current.date(byAdding: .day, value: -1, to: day.date)!
				if let prevDayEvents = visibleEvents[prevDayDate.yearMonthDay],
				   let existingEvent = prevDayEvents.first(where: { $0.id == event.id }) {
					rows.insert(existingEvent.rect.1)
				}
			}
		}
		
		// 이벤트에 행 할당
		var visibleEventList: [CalendarEvent] = []
		var nextRow = 0
		for event in filteredEvents {
			var updatedEvent = event
			
			// 요일 위치 계산
			let weekStartDate = day.date.startOfWeek
			var dayIndex = Calendar.current.dateComponents([.day], from: weekStartDate, to: event.date).day ?? 0
			dayIndex = max(0, min(dayIndex, weekRange - 1))
			
			// span 계산
			let eventEndDate = event.endDate ?? event.date
			var endDayIndex = Calendar.current.dateComponents([.day], from: weekStartDate, to: eventEndDate).day ?? 0
			endDayIndex = max(endDayIndex, dayIndex)
			endDayIndex = min(endDayIndex, weekRange - 1)
			
			let span = max(endDayIndex - dayIndex + 1, 1)
			let clampedSpan = min(span, weekRange - dayIndex)
			
			// 이벤트 행 할당
			let assignedRow: Int
			if let endDate = event.endDate,
			   Calendar.current.isDate(event.date, inSameDayAs: endDate) == false {
				// 연속 이벤트 - 기존 행 탐색
				let prevDayDate = Calendar.current.date(byAdding: .day, value: -1, to: day.date)!
				if let prevDayEvents = visibleEvents[prevDayDate.yearMonthDay],
				   let existingEvent = prevDayEvents.first(where: { $0.id == event.id }) {
					assignedRow = existingEvent.rect.1
				} else {
					// 연속 이벤트 - 새로운 행 할당
					while rows.contains(nextRow) {
						nextRow += 1
					}
					assignedRow = nextRow
					rows.insert(assignedRow)
					nextRow += 1
				}
			} else {
				// 단일 이벤트 - 행 할당
				while rows.contains(nextRow) {
					nextRow += 1
				}
				assignedRow = nextRow
				rows.insert(assignedRow)
				nextRow += 1
			}
			
			// RECT 설정
			updatedEvent.rect = (dayIndex, assignedRow, max(clampedSpan, 1), 1)
			
			// RangeType 설정
			if let endDate = event.endDate {
				let eventStartDay = event.date.yearMonthDay
				let eventEndDay = endDate.yearMonthDay
				let currentDay = day.date.yearMonthDay
				
				if eventStartDay == eventEndDay {
					updatedEvent.rangeType = .single
				} else if currentDay == eventStartDay {
					updatedEvent.rangeType = .start
				} else if currentDay == eventEndDay {
					updatedEvent.rangeType = .end
				} else {
					updatedEvent.rangeType = .middle
				}
			} else {
				updatedEvent.rangeType = .single
			}
			
			visibleEventList.append(updatedEvent)
		}
		
		return visibleEventList.sorted { $0.rect.1 < $1.rect.1 }
	}
}
