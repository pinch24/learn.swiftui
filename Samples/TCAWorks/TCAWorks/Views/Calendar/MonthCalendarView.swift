//
//  MonthCalendarView.swift
//  TCAWorks
//
//  Created by MK on 8/5/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Main Calendar View with Vertical Paging
struct MonthCalendarView: View {
	private let store: StoreOf<CalendarMainReducer>
	init(store: StoreOf<CalendarMainReducer>) {
		self.store = store
	}
	
	public enum ScrollDirection: Sendable { case none, up, down }
	@State private var scrollDirection = ScrollDirection.none
	@State private var scrollOffset: CGFloat = 0
	@State private var dragOffset: CGFloat = 0
	@State private var lastScaleValue: CGFloat = 1.0
	@State private var initialCellHeight: CGFloat = 120
	@State private var cellHeight: CGFloat = 120
	@State private var pinchLocation: CGPoint? = nil
	@State private var isDragging = false
	
	private let calendar = Calendar.current
	private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
	
	// Sample events
	fileprivate let sampleEvents: [CalendarEvent] = getCalendarEvent06() + getCalendarEvent07() + getCalendarEvent08() + getCalendarEvent09() + getCalendarEvent10()
	
	private func getWeeksCount(for month: Date) -> Int {
		let range = calendar.range(of: .day, in: .month, for: month)!
		let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
		let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
		
		let totalDays = firstWeekday + range.count
		return (totalDays + 6) / 7
	}
	
	var body: some View {
		VStack(spacing: 0) {
			// Weekday headers
			HStack(spacing: 0) {
				ForEach(weekdays, id: \.self) { day in
					Text(day)
						.font(.caption)
						.fontWeight(.medium)
						.frame(maxWidth: .infinity)
						.foregroundColor(.gray)
				}
			}
			.padding(.horizontal)
			.padding(.vertical, 10)
			.background(Color.background)
			
			// Calendar content
			pagingView
		}
		.background(Color.background)
	}
	
	private var pagingView: some View {
		GeometryReader { geo in
			let prevMonth = store.prevMonth
			let nextMonth = store.nextMonth
			let selectedMonth = store.selectedMonth
			let monthHeight = geo.size.height
			let hasPrevMonth = store.daysList[prevMonth] != nil
			let hasNextMonth = store.daysList[nextMonth] != nil
			
			ZStack {
				// 이전 월
				if hasPrevMonth {
					MonthView(
						month: prevMonth,
						cellHeight: cellHeight,
						sampleEvents: sampleEvents,
						scrollOffset: $scrollOffset
					)
					.frame(height: monthHeight - 44)
					.offset(y: -monthHeight + dragOffset)
					.opacity(dragOffset > 0 ? 1.0 : 0.0)
				}

				// 현재 월
				MonthView(
					month: selectedMonth,
					cellHeight: cellHeight,
					sampleEvents: sampleEvents,
					scrollOffset: $scrollOffset
				)
				.frame(height: monthHeight - 44)
				.offset(y: dragOffset)
				.opacity(1.0 - min(1.0, abs(dragOffset) / monthHeight) * 0.3)
				.scaleEffect(1.0 - min(1.0, abs(dragOffset) / monthHeight) * 0.05)

				// 다음 월
				if hasNextMonth {
					MonthView(
						month: nextMonth,
						cellHeight: cellHeight,
						sampleEvents: sampleEvents,
						scrollOffset: $scrollOffset
					)
					.frame(height: monthHeight - 44)
					.offset(y: monthHeight + dragOffset)
					.opacity(dragOffset < 0 ? 1.0 : 0.0)
				}
			}
			.clipped()
			.highPriorityGesture(
				// 드래그 제스처
				DragGesture(minimumDistance: 5)
					.onChanged { value in
						// 드래그 오프셋 업데이트
						dragOffset = value.translation.height
						// 방향 감지 및 데이터 로드
						if dragOffset > 50 {
							scrollDirection = .up
							if store.daysList[prevMonth] == nil {
								store.send(.viewAction(.setDaysList(prevMonth)))
							}
						} else if dragOffset < -50 {
							scrollDirection = .down
							if store.daysList[nextMonth] == nil {
								store.send(.viewAction(.setDaysList(nextMonth)))
							}
						} else {
							scrollDirection = .none
						}
					}
					.onEnded { value in
						let translation = value.translation.height
						let velocity = value.predictedEndTranslation.height - translation
						let threshold = monthHeight * 0.3  // 화면의 30% 이상 드래그하면 페이지 전환
						if translation > threshold || velocity > 50 {
							// 이전 월로 변경
							if store.daysList[prevMonth] != nil {
								dragOffset = monthHeight  // 애니메이션으로 이동
								store.send(.viewAction(.setSelectedMonth(prevMonth)))
								store.send(.viewAction(.setSelectedDay(nil)))
								dragOffset = 0
							} else {
								dragOffset = 0
							}
						} else if translation < -threshold || velocity < -50 {
							// 다음 월로 변경
							if store.daysList[nextMonth] != nil {
								dragOffset = -monthHeight  // 애니메이션으로 이동
								store.send(.viewAction(.setSelectedMonth(nextMonth)))
								store.send(.viewAction(.setSelectedDay(nil)))
								dragOffset = 0
							} else {
								dragOffset = 0
							}
						} else {
							// 원위치로 돌아가기
							dragOffset = 0
						}
						scrollDirection = .none
					}
			)
			.simultaneousGesture(
				// 핀치 제스처
				MagnificationGesture()
					.onChanged { value in
						if isDragging == false {
							// 첫 핀치 시작 시 초기값 저장
							if lastScaleValue == 1.0 {
								initialCellHeight = cellHeight
								// 핀치 중심점은 제스처 시작 시에만 설정
								if pinchLocation == nil {
									// MagnificationGesture는 중심점을 제공하지 않으므로 화면 중앙을 기본값으로 사용
									pinchLocation = CGPoint(
										x: geo.size.width / 2,
										y: geo.size.height / 2
									)
								}
							}
							
							// 스케일 계산
							let scale = value
							let weekdayHeaderHeight: CGFloat = 44
							let availableHeight = geo.size.height - weekdayHeaderHeight
							let weeksInMonth = getWeeksCount(for: Date.from(selectedMonth, format: "yyyy.MM"))
							let minHeightToFitAllWeeks = availableHeight / CGFloat(weeksInMonth)
							let newHeight = initialCellHeight * scale
							cellHeight = min(max(newHeight, max(60, minHeightToFitAllWeeks)), 400)
							lastScaleValue = value
						}
					}
					.onEnded { _ in
						lastScaleValue = 1.0
						pinchLocation = nil
						initialCellHeight = cellHeight
					}
			)
		}
	}
}

// MARK: - Month View
fileprivate struct MonthView: View {
	let month: String
	let monthDate: Date
	let cellHeight: CGFloat
	let sampleEvents: [CalendarEvent]
	@Binding var scrollOffset: CGFloat
	
	private let calendar = Calendar.current
	private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
	
	init(month: String, cellHeight: CGFloat, sampleEvents: [CalendarEvent], scrollOffset: Binding<CGFloat>) {
		self.month = month
		self.monthDate = Date.from(month, format: "yyyy.MM")
		self.cellHeight = cellHeight
		self.sampleEvents = sampleEvents
		self._scrollOffset = scrollOffset
	}
	
	var body: some View {
		VStack(spacing: 0) {
			ScrollViewReader { proxy in
				ScrollView {
					VStack(spacing: 0) {
						ForEach(Array(getWeeksInMonth().enumerated()), id: \.offset) { index, week in
							WeekRow(
								weekDates: week,
								currentMonth: monthDate,
								singleDayEvents: getSingleDayEvents(),
								multiDayEvents: getMultiDayEvents(for: week),
								cellHeight: cellHeight
							)
						}
					}
					.background(
						GeometryReader { geo in
							Color.clear.preference(
								key: ScrollOffsetPreferenceKey.self,
								value: geo.frame(in: .named("scroll")).minY
							)
						}
					)
				}
				.coordinateSpace(name: "scroll")
				.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
					scrollOffset = value
				}
			}
		}
	}
	
	private func getWeeksInMonth() -> [[Date]] {
		var weeks: [[Date]] = []
		var days: [Date] = []
		
		let range = calendar.range(of: .day, in: .month, for: monthDate)!
		let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate))!
		let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
		
		// 이전 달의 끝 날짜들
		for i in (1...max(1, firstWeekday)).reversed() {
			if let date = calendar.date(byAdding: .day, value: -i, to: firstDayOfMonth) {
				days.append(date)
			}
		}
		
		// 현재 월의 날짜들
		for i in 0..<range.count {
			if let date = calendar.date(byAdding: .day, value: i, to: firstDayOfMonth) {
				days.append(date)
			}
		}
		
		// 다음 달의 앞 날짜들
		while days.count % 7 != 0 {
			if let lastDay = days.last,
			   let date = calendar.date(byAdding: .day, value: 1, to: lastDay) {
				days.append(date)
			}
		}
		
		// 각 주차에 날짜들 추가
		for i in stride(from: 0, to: days.count, by: 7) {
			let week = Array(days[i..<min(i + 7, days.count)])
			weeks.append(week)
		}
		
		return weeks
	}
	
	private func getSingleDayEvents() -> [Date: [CalendarEvent]] {
		var eventsByDate: [Date: [CalendarEvent]] = [:]
		
		for event in sampleEvents {
			if event.endDate == nil || calendar.isDate(event.date, inSameDayAs: event.endDate!) {
				let date = calendar.startOfDay(for: event.date)
				if eventsByDate[date] != nil {
					eventsByDate[date]?.append(event)
				} else {
					eventsByDate[date] = [event]
				}
			}
		}
		
		return eventsByDate
	}
	
	private func getMultiDayEvents(for week: [Date]) -> [CalendarEvent] {
		sampleEvents.filter { event in
			event.endDate != nil && !calendar.isDate(event.date, inSameDayAs: event.endDate!) &&
			doesEventOverlapWeek(event: event, week: week)
		}.sorted { $0.date < $1.date }
	}
	
	private func doesEventOverlapWeek(event: CalendarEvent, week: [Date]) -> Bool {
		guard let weekStart = week.first, let weekEnd = week.last else { return false }
		
		let eventStart = calendar.startOfDay(for: event.date)
		let eventEnd = calendar.startOfDay(for: event.endDate ?? event.date)
		let weekStartDay = calendar.startOfDay(for: weekStart)
		let weekEndDay = calendar.startOfDay(for: weekEnd)
		
		return eventEnd >= weekStartDay && eventStart <= weekEndDay
	}
}

fileprivate struct ScrollOffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

// MARK: - 주 단위 행
fileprivate struct WeekRow: View {
	let weekDates: [Date]
	let currentMonth: Date
	let singleDayEvents: [Date: [CalendarEvent]]
	let multiDayEvents: [CalendarEvent]
	let cellHeight: CGFloat
	
	private let calendar = Calendar.current
	
	var body: some View {
		ZStack(alignment: .top) {
			// 단일 날짜 이벤트
			HStack(spacing: 0) {
				ForEach(weekDates, id: \.self) { date in
					DayCell(
						date: date,
						isCurrentMonth: isCurrentMonth(date),
						isToday: isToday(date),
						events: singleDayEvents[calendar.startOfDay(for: date)] ?? [],
						cellHeight: cellHeight,
						multiDayEventCount: countMultiDayEvents(for: date)
					)
				}
			}
			
			// 여러 날짜 이벤트
			VStack(spacing: 2) {
				Color.clear.frame(height: 36)
				ForEach(Array(multiDayEvents.enumerated()), id: \.element.id) { index, event in
					if shouldShowEvent(event) {
						MultiDayCell(
							event: event,
							weekRange: weekDates,
							cellHeight: cellHeight
						)
						.frame(height: cellHeight > 80 ? 20 : 16)
					}
				}
			}
			.allowsHitTesting(false)
		}
		.frame(height: cellHeight)
	}
	
	private func isCurrentMonth(_ date: Date) -> Bool {
		calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
	}
	
	private func isToday(_ date: Date) -> Bool {
		calendar.isDateInToday(date)
	}
	
	private func shouldShowEvent(_ event: CalendarEvent) -> Bool {
		let weekStart = calendar.startOfDay(for: weekDates.first!)
		let weekEnd = calendar.startOfDay(for: weekDates.last!)
		let eventStart = calendar.startOfDay(for: event.date)
		let eventEnd = calendar.startOfDay(for: event.endDate ?? event.date)
		
		return eventEnd >= weekStart && eventStart <= weekEnd
	}
	
	private func countMultiDayEvents(for date: Date) -> Int {
		multiDayEvents.filter { event in
			let dayStart = calendar.startOfDay(for: date)
			let eventStart = calendar.startOfDay(for: event.date)
			let eventEnd = calendar.startOfDay(for: event.endDate ?? event.date)
			return dayStart >= eventStart && dayStart <= eventEnd
		}.count
	}
}

// MARK: - 여러 날짜 이벤트
fileprivate struct MultiDayCell: View {
	let event: CalendarEvent
	let weekRange: [Date]
	let cellHeight: CGFloat
	
	private let calendar = Calendar.current
	
	var body: some View {
		if let startIndex = getStartIndex(), let endIndex = getEndIndex() {
			GeometryReader { geometry in
				let cellWidth = geometry.size.width / 7
				let xOffset = CGFloat(startIndex) * cellWidth
				let width = CGFloat(endIndex - startIndex + 1) * cellWidth - 1
				
				HStack(spacing: 0) {
					Text(event.title)
						.font(.system(size: cellHeight > 80 ? 12 : 10))
						.foregroundColor(.white)
						.lineLimit(1)
						.padding(.horizontal, 6)
						.padding(.vertical, 2)
					Spacer()
				}
				.frame(width: width, height: cellHeight > 80 ? 20 : 16)
				.background(event.textColor)
				.cornerRadius(4)
				.offset(x: xOffset, y: 0)
			}
		}
	}
	
	private func getStartIndex() -> Int? {
		let eventStart = calendar.startOfDay(for: event.date)
		let weekStart = calendar.startOfDay(for: weekRange.first!)
		
		if eventStart <= weekStart {
			return 0
		} else if let index = weekRange.firstIndex(where: { calendar.isDate($0, inSameDayAs: eventStart) }) {
			return index
		}
		return nil
	}
	
	private func getEndIndex() -> Int? {
		let eventEnd = calendar.startOfDay(for: event.endDate ?? event.date)
		let weekEnd = calendar.startOfDay(for: weekRange.last!)
		
		if eventEnd >= weekEnd {
			return 6
		} else if let index = weekRange.firstIndex(where: { calendar.isDate($0, inSameDayAs: eventEnd) }) {
			return index
		}
		return nil
	}
}

// MARK: - 단일 날짜 이벤트
fileprivate struct DayCell: View {
	let date: Date
	let isCurrentMonth: Bool
	let isToday: Bool
	let events: [CalendarEvent]
	let cellHeight: CGFloat
	let multiDayEventCount: Int
	
	private var dayFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "d"
		return formatter
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 2) {
			// Day number
			Text(dayFormatter.string(from: date))
				.font(.system(size: 16, weight: isToday ? .bold : .regular))
				.foregroundColor(isToday ? .white : (isCurrentMonth ? .primary : .gray))
				.frame(width: 28, height: 28)
				.background(
					Circle()
						.fill(isToday ? Color.red : Color.clear)
				)
				.padding(.top, 4)
				.padding(.leading, 4)
			
			// Single day events (skip space for multi-day events)
			if cellHeight > 60 {
				VStack(alignment: .leading, spacing: 2) {
					// Add spacing for multi-day events
					ForEach(0..<multiDayEventCount, id: \.self) { _ in
						Color.clear.frame(height: cellHeight > 80 ? 22 : 18)
					}
					
					// Single day events
					let maxEvents = Int((cellHeight - 40 - CGFloat(multiDayEventCount * 22)) / 20)
					ForEach(Array(events.prefix(maxEvents))) { event in
						HStack(spacing: 4) {
							Text(event.title)
								.font(.system(size: 11))
								.lineLimit(1)
								.truncationMode(.tail)
						}
						.padding(.horizontal, 4)
					}
				}
			} else if !events.isEmpty || multiDayEventCount > 0 {
				// Dots indicator when collapsed
				HStack(spacing: 2) {
					let dotCount = min(events.count + multiDayEventCount, 3)
					ForEach(0..<dotCount, id: \.self) { index in
						Circle()
							.fill(index < multiDayEventCount ? Color.blue : events[index - multiDayEventCount].textColor)
							.frame(width: 6, height: 6)
					}
				}
				.padding(.leading, 4)
				.padding(.top, 4)
			}
			
			Spacer(minLength: 0)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.background)
		.overlay(
			Rectangle()
				.stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
		)
	}
}

#Preview {
	MonthCalendarPreview()
}

struct MonthCalendarPreview: View {
	var body: some View {
		MonthCalendarView(
			store: Store(
				initialState: CalendarMainReducer.State(events: CalendarMainPreview.getCalendarEvent06()),
				reducer: { CalendarMainReducer() }
			)
		)
	}
}

// TEST DATA
fileprivate func getCalendarEvent06() -> [CalendarEvent] {
	[
		CalendarEvent(
			date: Date.from("2025.05.05"),
			endDate: nil,
			title: "부처님오신날",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),
		CalendarEvent(
			date: Date.from("2025.05.05"),
			endDate: nil,
			title: "어린이날",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),

		CalendarEvent(
			date: Date.from("2025.05.06"),
			endDate: nil,
			title: "어린이날(대체휴일)",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),

		CalendarEvent(
			date: Date.from("2025.06.03"),
			endDate: nil,
			title: "대통령 선거일",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),
		CalendarEvent(
			date: Date.from("2025.06.06"),
			endDate: nil,
			title: "현충일",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),

		CalendarEvent(
			date: Date.from("2025.06.25"),
			endDate: nil,
			title: "문화의 날",
			textColor: Color.purple,
			labelColor: Color.purple.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),

		CalendarEvent(
			date: Date.from("2025.06.04 11:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.04 11:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "D-TF 주간회의",
			textColor: Color.orange,
			labelColor: Color.orange.opacity(0.1),
			notes: "Daily sync meeting with team",
			location: "페이코룸",
			participants: ["앨리스", "밥", "찰리"],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),
		CalendarEvent(
			date: Date.from("2025.06.04 12:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.04 12:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "점심회식",
			textColor: Color.green,
			labelColor: Color.green.opacity(0.1),
			notes: "Daily sync meeting with team",
			location: "팔복",
			participants: ["앨리스", "밥", "찰리"],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.04 12:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.04 12:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "진행상황공유",
			textColor: Color.green,
			labelColor: Color.green.opacity(0.1),
			notes: "Daily sync meeting with team",
			location: "로비",
			participants: ["밥", "찰리"],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),

		CalendarEvent(
			date: Date.from("2025.06.05 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.05 15:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "프로덕트디자인",
			textColor: Color.cyan,
			labelColor: Color.cyan.opacity(0.1),
			notes: "",
			location: "컨퍼런스룸",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "[공유] 프로덕트디자인1팀",
		),
		CalendarEvent(
			date: Date.from("2025.06.05 16:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.05 16:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "시안공유",
			textColor: Color.indigo,
			labelColor: Color.indigo.opacity(0.1),
			notes: "",
			location: "컨퍼런스룸",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] 프로덕트디자인1팀",
		),
		CalendarEvent(
			date: Date.from("2025.06.5 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.5 17:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "시안공유",
			textColor: Color.green,
			labelColor: Color.green.opacity(0.1),
			notes: "Sprint planning for Q3",
			location: "8-0",
			participants: ["제품팀"],
			scheduleType: .canceled,
			rect: (0, 0, 0, 0),
			category: "[공유] 프로덕트디자인1팀",
		),

		CalendarEvent(
			date: Date.from("2025.06.09 10:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.09 11:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "10월2주",
			textColor: Color.mint,
			labelColor: Color.mint.opacity(0.1),
			notes: "스프린트",
			location: "",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),
		CalendarEvent(
			date: Date.from("2025.06.09 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.09 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "D-TF 주간회의",
			textColor: Color.cyan,
			labelColor: Color.cyan.opacity(0.1),
			notes: "회의",
			location: "Zoom",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),
		CalendarEvent(
			date: Date.from("2025.06.09 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.09 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "[북토크]도망친 나라에 안식은 없다",
			textColor: Color.teal,
			labelColor: Color.teal.opacity(0.1),
			notes: "활동",
			location: "Zoom",
			participants: [],
			scheduleType: .closed,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.09 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.09 17:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "방향성 보고",
			textColor: Color.brown,
			labelColor: Color.brown.opacity(0.1),
			notes: "",
			location: "8-3",
			participants: ["루키"],
			scheduleType: .canceled,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),

		CalendarEvent(
			date: Date.from("2025.06.10 18:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.10 19:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "프로덕트디자인",
			textColor: Color.pink,
			labelColor: Color.pink.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] 프로덕트디자인1팀",
		),

		CalendarEvent(
			date: Date.from("2025.06.11 18:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.11 19:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "프로덕트디자인",
			textColor: Color.green,
			labelColor: Color.green.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] 프로덕트디자인1팀",
		),

		CalendarEvent(
			date: Date.from("2025.06.12"),
			endDate: Date.from("2025.06.13"),
			title: "[휴가] 조예리",
			textColor: Color.yellow,
			labelColor: Color.yellow.opacity(0.1),
			notes: "개인사유",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),
		CalendarEvent(
			date: Date.from("2025.06.12"),
			endDate: Date.from("2025.06.18"),
			title: "플레이뮤지엄 리뉴얼",
			textColor: Color.blue,
			labelColor: Color.blue.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .free,
			rect: (0, 0, 0, 0),
			category: "NHN 디자인실",
		),
		CalendarEvent(
			date: Date.from("2025.06.12"),
			endDate: Date.from("2025.06.12"),
			title: "직무교육",
			textColor: Color.gray,
			labelColor: Color.gray.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.12"),
			endDate: Date.from("2025.06.12"),
			title: "D! K/O 1",
			textColor: Color.teal,
			labelColor: Color.teal.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),
		CalendarEvent(
			date: Date.from("2025.06.12"),
			endDate: Date.from("2025.06.12"),
			title: "D! K/O 2",
			textColor: Color.teal,
			labelColor: Color.teal.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),
		CalendarEvent(
			date: Date.from("2025.06.12"),
			endDate: Date.from("2025.06.12"),
			title: "D! K/O 3",
			textColor: Color.teal,
			labelColor: Color.teal.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),
		CalendarEvent(
			date: Date.from("2025.06.12"),
			endDate: Date.from("2025.06.12"),
			title: "D! K/O 4",
			textColor: Color.teal,
			labelColor: Color.teal.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),
		CalendarEvent(
			date: Date.from("2025.06.12"),
			endDate: Date.from("2025.06.12"),
			title: "D! K/O 5",
			textColor: Color.teal,
			labelColor: Color.teal.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),
		CalendarEvent(
			date: Date.from("2025.06.12"),
			endDate: Date.from("2025.06.12"),
			title: "D! K/O 6",
			textColor: Color.teal,
			labelColor: Color.teal.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] D-TF",
		),

		CalendarEvent(
			date: Date.from("2025.06.17 18:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.17 19:59:59", format: "yyyy.MM.dd HH:mm:ss"),
			title: "프로덕트디자인",
			textColor: Color.purple,
			labelColor: Color.purple.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .busy,
			rect: (0, 0, 0, 0),
			category: "[공유] 프로덕트디자인1팀",
		),

		CalendarEvent(
			date: Date.from("2025.06.24 08:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.24 09:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "교육 1",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "교육",
			location: "Zoom",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.24 09:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.24 10:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "교육 2",
			textColor: Color.green,
			labelColor: Color.green.opacity(0.1),
			notes: "교육",
			location: "Zoom",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.24 10:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.24 11:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "교육 3",
			textColor: Color.orange,
			labelColor: Color.orange.opacity(0.1),
			notes: "교육",
			location: "Zoom",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.24 12:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.24 13:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "교육 4",
			textColor: Color.mint,
			labelColor: Color.mint.opacity(0.1),
			notes: "교육",
			location: "Zoom",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.24 13:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.24 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "교육 5",
			textColor: Color.gray,
			labelColor: Color.gray.opacity(0.1),
			notes: "교육",
			location: "Zoom",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.24 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.24 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "교육 6",
			textColor: Color.pink,
			labelColor: Color.pink.opacity(0.1),
			notes: "교육",
			location: "Zoom",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.24 14:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.24 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "교육 7",
			textColor: Color.cyan,
			labelColor: Color.cyan.opacity(0.1),
			notes: "교육",
			location: "Zoom",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.24 15:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.24 16:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "교육 8",
			textColor: Color.cyan,
			labelColor: Color.cyan.opacity(0.1),
			notes: "교육",
			location: "Zoom",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
		CalendarEvent(
			date: Date.from("2025.06.24 16:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			endDate: Date.from("2025.06.24 17:00:00", format: "yyyy.MM.dd HH:mm:ss"),
			title: "교육 9",
			textColor: Color.cyan,
			labelColor: Color.cyan.opacity(0.1),
			notes: "교육",
			location: "Zoom",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
	]
}
fileprivate func getCalendarEvent07() -> [CalendarEvent] {
	[
		CalendarEvent(
			date: Date.from("2025.07.30"),
			endDate: nil,
			title: "문화의 날",
			textColor: Color.purple,
			labelColor: Color.purple.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),

		CalendarEvent(
			date: Date.from("2025.07.17"),
			endDate: Date.from("2025.07.21"),
			title: "연속 이벤트 - 1. Hello, world.",
			textColor: Color.indigo,
			labelColor: Color.indigo.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Waplat-Project",
		),

		CalendarEvent(
			date: Date.from("2025.07.18"),
			endDate: Date.from("2025.07.22"),
			title: "연속 이벤트 - 2. It's no use crying over spilt milk.",
			textColor: Color.orange,
			labelColor: Color.orange.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Waplat-Project",
		),

		CalendarEvent(
			date: Date.from("2025.07.23"),
			endDate: Date.from("2025.07.28"),
			title: "연속 이벤트 - 3. Life goes on.",
			textColor: Color.brown,
			labelColor: Color.brown.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .task,
			rect: (0, 0, 0, 0),
			category: "Waplat-Project",
		),
	]
}
fileprivate func getCalendarEvent08() -> [CalendarEvent] {
	[
		CalendarEvent(
			date: Date.from("2025.08.15"),
			endDate: nil,
			title: "광복절",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),
		CalendarEvent(
			date: Date.from("2025.08.27"),
			endDate: nil,
			title: "문화의 날",
			textColor: Color.purple,
			labelColor: Color.purple.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
	]
}
fileprivate func getCalendarEvent09() -> [CalendarEvent] {
	[
		CalendarEvent(
			date: Date.from("2025.09.24"),
			endDate: nil,
			title: "문화의 날",
			textColor: Color.purple,
			labelColor: Color.purple.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
	]
}
fileprivate func getCalendarEvent10() -> [CalendarEvent] {
	[
		CalendarEvent(
			date: Date.from("2025.10.03"),
			endDate: nil,
			title: "개천절",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),
		CalendarEvent(
			date: Date.from("2025.10.04"),
			endDate: Date.from("2025.10.08"),
			title: "추석",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),
		CalendarEvent(
			date: Date.from("2025.10.09"),
			endDate: nil,
			title: "한글날",
			textColor: Color.red,
			labelColor: Color.red.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "대한민국 휴일",
		),
		CalendarEvent(
			date: Date.from("2025.10.29"),
			endDate: nil,
			title: "문화의 날",
			textColor: Color.purple,
			labelColor: Color.purple.opacity(0.1),
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			rect: (0, 0, 0, 0),
			category: "Dooray!",
		),
	]
}
