//
//  MonthCalendarView.swift
//  TCAWorks
//
//  Created by MK on 8/5/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Multi-day Event View
fileprivate struct MultiDayEventView: View {
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

// MARK: - Calendar Week Row
fileprivate struct CalendarWeekRow: View {
	let weekDates: [Date]
	let currentMonth: Date
	let singleDayEvents: [Date: [CalendarEvent]]
	let multiDayEvents: [CalendarEvent]
	let cellHeight: CGFloat
	
	private let calendar = Calendar.current
	
	var body: some View {
		ZStack(alignment: .top) {
			// Day cells
			HStack(spacing: 0) {
				ForEach(weekDates, id: \.self) { date in
					CalendarDayCell(
						date: date,
						isCurrentMonth: isCurrentMonth(date),
						isToday: isToday(date),
						events: singleDayEvents[calendar.startOfDay(for: date)] ?? [],
						cellHeight: cellHeight,
						multiDayEventCount: countMultiDayEvents(for: date)
					)
				}
			}
			
			// Multi-day events overlay
			VStack(spacing: 2) {
				// Reserve space for day numbers
				Color.clear.frame(height: 36)
				
				// Multi-day events
				ForEach(Array(multiDayEvents.enumerated()), id: \.element.id) { index, event in
					if shouldShowEvent(event) {
						MultiDayEventView(
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

// MARK: - Calendar Cell View
fileprivate struct CalendarDayCell: View {
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
		.background(Color(UIColor.systemBackground))
		.overlay(
			Rectangle()
				.stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
		)
	}
}

// MARK: - Month View
fileprivate struct MonthView: View {
	let month: Date
	let cellHeight: CGFloat
	let sampleEvents: [CalendarEvent]
	@Binding var scrollOffset: CGFloat
	let monthIndex: Int
	
	private let calendar = Calendar.current
	private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
	
	var body: some View {
		VStack(spacing: 0) {
			// Calendar grid
			ScrollViewReader { proxy in
				ScrollView {
					VStack(spacing: 0) {
						ForEach(Array(getWeeksInMonth().enumerated()), id: \.offset) { index, week in
							CalendarWeekRow(
								weekDates: week,
								currentMonth: month,
								singleDayEvents: getSingleDayEvents(),
								multiDayEvents: getMultiDayEvents(for: week),
								cellHeight: cellHeight
							)
							.id("\(monthIndex)-\(index)")
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
	
	// MARK: - Helper Functions
	private func getWeeksInMonth() -> [[Date]] {
		var weeks: [[Date]] = []
		var days: [Date] = []
		
		let range = calendar.range(of: .day, in: .month, for: month)!
		let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
		let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
		
		// Add previous month's trailing days
		for i in (1...firstWeekday).reversed() {
			if let date = calendar.date(byAdding: .day, value: -i, to: firstDayOfMonth) {
				days.append(date)
			}
		}
		
		// Add current month's days
		for i in 0..<range.count {
			if let date = calendar.date(byAdding: .day, value: i, to: firstDayOfMonth) {
				days.append(date)
			}
		}
		
		// Add next month's leading days
		while days.count % 7 != 0 {
			if let lastDay = days.last,
			   let date = calendar.date(byAdding: .day, value: 1, to: lastDay) {
				days.append(date)
			}
		}
		
		// Group into weeks
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

// Preference key for tracking scroll offset
fileprivate struct ScrollOffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

// MARK: - Main Calendar View with Vertical Paging
struct MonthCalendarView: View {
	@State private var currentMonthIndex = 0
	@State private var cellHeight: CGFloat = 120
	@State private var lastScaleValue: CGFloat = 1.0
	@State private var dragOffset: CGFloat = 0
	@State private var isDragging = false
	@State private var scrollOffset: CGFloat = 0
	@State private var pinchLocation: CGPoint? = nil
	@State private var initialCellHeight: CGFloat = 120
	
	private let calendar = Calendar.current
	private let months: [Date]
	private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
	
	// Sample events
	fileprivate let sampleEvents: [CalendarEvent] = getCalendarEvent06() + getCalendarEvent07() + getCalendarEvent08() + getCalendarEvent09() + getCalendarEvent10()
	
	init() {
		// Generate months for scrolling (past 12 months to future 12 months)
		var tempMonths: [Date] = []
		let today = Date()
		for i in -12...12 {
			if let month = Calendar.current.date(byAdding: .month, value: i, to: today) {
				tempMonths.append(month)
			}
		}
		self.months = tempMonths
		
		// Set current month index
		if let todayIndex = tempMonths.firstIndex(where: { Calendar.current.isDate($0, equalTo: today, toGranularity: .month) }) {
			self._currentMonthIndex = State(initialValue: todayIndex)
		}
	}
	
	private var yearMonthFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.dateFormat = "yyyy년 M월"
		return formatter
	}
	
	private var currentMonth: Date {
		months[currentMonthIndex]
	}
	
	private var prevMonth: Date? {
		guard currentMonthIndex > 0 else { return nil }
		return months[currentMonthIndex - 1]
	}
	
	private var nextMonth: Date? {
		guard currentMonthIndex < months.count - 1 else { return nil }
		return months[currentMonthIndex + 1]
	}
	
	private var hasPrevMonth: Bool {
		currentMonthIndex > 0
	}
	
	private var hasNextMonth: Bool {
		currentMonthIndex < months.count - 1
	}
	
	private func getWeeksCount(for month: Date) -> Int {
		let range = calendar.range(of: .day, in: .month, for: month)!
		let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
		let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
		
		let totalDays = firstWeekday + range.count
		return (totalDays + 6) / 7 // Round up to get number of weeks
	}
	
	var body: some View {
		NavigationView {
			GeometryReader { geo in
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
					.background(Color(UIColor.systemBackground))
					
					// Calendar months with vertical paging
					ZStack {
						// Previous month
						if hasPrevMonth {
							monthView(prevMonth!, height: geo.size.height - 44, geo: geo, monthIndex: currentMonthIndex - 1)
								.offset(y: -geo.size.height + dragOffset)
						}
						
						// Current month
						monthView(currentMonth, height: geo.size.height - 44, geo: geo, monthIndex: currentMonthIndex)
							.offset(y: dragOffset)
						
						// Next month
						if hasNextMonth {
							monthView(nextMonth!, height: geo.size.height - 44, geo: geo, monthIndex: currentMonthIndex + 1)
								.offset(y: geo.size.height + dragOffset)
						}
					}
					.clipped()
					.gesture(
						DragGesture()
							.onChanged { value in
								isDragging = true
								dragOffset = value.translation.height
							}
							.onEnded { value in
								withAnimation(.spring()) {
									let threshold = geo.size.height * 0.3
									
									if value.translation.height > threshold && hasPrevMonth {
										// Swipe down - go to previous month
										currentMonthIndex -= 1
									} else if value.translation.height < -threshold && hasNextMonth {
										// Swipe up - go to next month
										currentMonthIndex += 1
									}
									
									dragOffset = 0
									isDragging = false
								}
							}
					)
					.simultaneousGesture(
						MagnificationGesture()
							.onChanged { value in
								if !isDragging {
									// 첫 핀치 시작 시 초기값 저장
									if lastScaleValue == 1.0 {
										initialCellHeight = cellHeight
										// 핀치 중심점은 제스처 시작 시에만 설정
										if pinchLocation == nil {
											// MagnificationGesture는 중심점을 제공하지 않으므로
											// 화면 중앙을 기본값으로 사용
											pinchLocation = CGPoint(
												x: geo.size.width / 2,
												y: geo.size.height / 2
											)
										}
									}
									
									// 스케일 계산
									let scale = value
									
									// Calculate minimum height to keep last week visible
									let weekdayHeaderHeight: CGFloat = 44
									let availableHeight = geo.size.height - weekdayHeaderHeight
									let weeksInMonth = getWeeksCount(for: currentMonth)
									let minHeightToFitAllWeeks = availableHeight / CGFloat(weeksInMonth)
									
									// Update cell height with constraints
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
				.background(Color(UIColor.systemBackground))
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Text(yearMonthFormatter.string(from: currentMonth))
						.font(.headline)
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					HStack(spacing: 20) {
						Button(action: {
							// Today button - scroll to current month
							withAnimation {
								if let todayIndex = months.firstIndex(where: { calendar.isDate($0, equalTo: Date(), toGranularity: .month) }) {
									currentMonthIndex = todayIndex
								}
							}
						}) {
							Text("오늘")
								.font(.system(size: 14))
						}
						Button(action: {}) {
							Image(systemName: "calendar")
						}
					}
				}
			}
		}
	}
	
	@ViewBuilder
	private func monthView(_ month: Date, height: CGFloat, geo: GeometryProxy, monthIndex: Int) -> some View {
		MonthView(
			month: month,
			cellHeight: cellHeight,
			sampleEvents: sampleEvents,
			scrollOffset: $scrollOffset,
			monthIndex: monthIndex
		)
		.frame(height: height)
	}
}

#Preview {
	MonthCalendarView()
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
			endDate: Date.from("2025.06.13"),
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
			endDate: Date.from("2025.07.02"),
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
