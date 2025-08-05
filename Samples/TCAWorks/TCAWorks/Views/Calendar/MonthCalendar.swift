//
//  MonthCalendar.swift
//  TCAWorks
//
//  Created by MK on 8/5/25.
//

//
//  CalendarMonth.swift
//  CalendarNew
//
//  Created by Mk on 8/5/25.
//

import SwiftUI

// MARK: - Models
struct DayEvent: Identifiable {
	let id = UUID()
	let title: String
	let startDate: Date
	let endDate: Date
	let color: Color
	let isAllDay: Bool
	
	// Single day event convenience initializer
	init(title: String, date: Date, color: Color, isAllDay: Bool = false) {
		self.title = title
		self.startDate = date
		self.endDate = date
		self.color = color
		self.isAllDay = isAllDay
	}
	
	// Multi-day event initializer
	init(title: String, startDate: Date, endDate: Date, color: Color, isAllDay: Bool = true) {
		self.title = title
		self.startDate = startDate
		self.endDate = endDate
		self.color = color
		self.isAllDay = isAllDay
	}
}

// MARK: - Multi-day Event View
struct MultiDayEventView: View {
	let event: DayEvent
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
				.background(event.color)
				.cornerRadius(4)
				.offset(x: xOffset, y: 0)
			}
		}
	}
	
	private func getStartIndex() -> Int? {
		let eventStart = calendar.startOfDay(for: event.startDate)
		let weekStart = calendar.startOfDay(for: weekRange.first!)
		
		if eventStart <= weekStart {
			return 0
		} else if let index = weekRange.firstIndex(where: { calendar.isDate($0, inSameDayAs: eventStart) }) {
			return index
		}
		return nil
	}
	
	private func getEndIndex() -> Int? {
		let eventEnd = calendar.startOfDay(for: event.endDate)
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
struct CalendarWeekRow: View {
	let weekDates: [Date]
	let currentMonth: Date
	let singleDayEvents: [Date: [DayEvent]]
	let multiDayEvents: [DayEvent]
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
	
	private func shouldShowEvent(_ event: DayEvent) -> Bool {
		let weekStart = calendar.startOfDay(for: weekDates.first!)
		let weekEnd = calendar.startOfDay(for: weekDates.last!)
		let eventStart = calendar.startOfDay(for: event.startDate)
		let eventEnd = calendar.startOfDay(for: event.endDate)
		
		return eventEnd >= weekStart && eventStart <= weekEnd
	}
	
	private func countMultiDayEvents(for date: Date) -> Int {
		multiDayEvents.filter { event in
			let dayStart = calendar.startOfDay(for: date)
			let eventStart = calendar.startOfDay(for: event.startDate)
			let eventEnd = calendar.startOfDay(for: event.endDate)
			return dayStart >= eventStart && dayStart <= eventEnd
		}.count
	}
}

// MARK: - Calendar Cell View
struct CalendarDayCell: View {
	let date: Date
	let isCurrentMonth: Bool
	let isToday: Bool
	let events: [DayEvent]
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
					ForEach(events.prefix(Int((cellHeight - 40 - CGFloat(multiDayEventCount * 22)) / 20))) { event in
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
					ForEach(0..<min(events.count + multiDayEventCount, 3), id: \.self) { index in
						Circle()
							.fill(index < multiDayEventCount ? Color.blue : events[index - multiDayEventCount].color)
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
struct MonthView: View {
	let month: Date
	let cellHeight: CGFloat
	let sampleEvents: [DayEvent]
	@Binding var scrollOffset: CGFloat
	let monthIndex: Int
	
	private let calendar = Calendar.current
	private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
	
	private var monthYearFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.dateFormat = "M월"
		return formatter
	}
	
	var body: some View {
		VStack(spacing: 0) {
			// Month header
			HStack {
				Text(monthYearFormatter.string(from: month))
					.font(.largeTitle)
					.fontWeight(.bold)
				Spacer()
			}
			.padding(.horizontal)
			.padding(.vertical, 10)
			
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
	
	private func getSingleDayEvents() -> [Date: [DayEvent]] {
		var eventsByDate: [Date: [DayEvent]] = [:]
		
		for event in sampleEvents {
			if calendar.isDate(event.startDate, inSameDayAs: event.endDate) {
				let date = calendar.startOfDay(for: event.startDate)
				if eventsByDate[date] != nil {
					eventsByDate[date]?.append(event)
				} else {
					eventsByDate[date] = [event]
				}
			}
		}
		
		return eventsByDate
	}
	
	private func getMultiDayEvents(for week: [Date]) -> [DayEvent] {
		sampleEvents.filter { event in
			!calendar.isDate(event.startDate, inSameDayAs: event.endDate) &&
			doesEventOverlapWeek(event: event, week: week)
		}.sorted { $0.startDate < $1.startDate }
	}
	
	private func doesEventOverlapWeek(event: DayEvent, week: [Date]) -> Bool {
		guard let weekStart = week.first, let weekEnd = week.last else { return false }
		
		let eventStart = calendar.startOfDay(for: event.startDate)
		let eventEnd = calendar.startOfDay(for: event.endDate)
		let weekStartDay = calendar.startOfDay(for: weekStart)
		let weekEndDay = calendar.startOfDay(for: weekEnd)
		
		return eventEnd >= weekStartDay && eventStart <= weekEndDay
	}
}

// Preference key for tracking scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

// MARK: - Main Calendar View with Vertical Paging
struct MonthCalendar: View {
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
	let sampleEvents: [DayEvent] = [
		// Single day events
		DayEvent(title: "알콜", date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 5))!, color: .orange),
		DayEvent(title: "업무 사이드 메뉴 바인딩", date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 5))!, color: .gray),
		DayEvent(title: "미팅", date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 8))!, color: .orange),
		DayEvent(title: "G-Con 2025 신청 마감", date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 9))!, color: .red),
		DayEvent(title: "회의", date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 14))!, color: .orange),
		
		// Multi-day events
		DayEvent(
			title: "캘린더 월간뷰 추가 UI",
			startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 27))!,
			endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 6))!,
			color: .red
		),
		DayEvent(
			title: "업무 홈 바인딩",
			startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 27))!,
			endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 1))!,
			color: .green
		),
		DayEvent(
			title: "메일 사이드 메뉴 바인딩",
			startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 1))!,
			endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 4))!,
			color: .blue
		),
		DayEvent(
			title: "문화의 날",
			startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 29))!,
			endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 30))!,
			color: .cyan
		),
		DayEvent(
			title: "캘린더 퍼포먼스 개선",
			startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 1))!,
			endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 4))!,
			color: .indigo
		),
		DayEvent(
			title: "업무 수정 사항 반영",
			startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 3))!,
			endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 5))!,
			color: .yellow
		),
		DayEvent(
			title: "광복절",
			startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 15))!,
			endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 15))!,
			color: .orange
		),
	]
	
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
	MonthCalendar()
}
