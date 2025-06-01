//
//  CalendarTypes.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import SwiftUI

public enum CalendarMode: Sendable { case day, week, month, year }

// UI 데이터 - 월간 캘린더의 그리드 셀을 그릴 때 사용
public struct CalendarDay: Hashable {
	public let date: Date
	public let day: Int
	public let isInMonth: Bool
	public let isToday: Bool
	public let isWeekend: Bool
	public let events: [CalendarEvent]?
	
	public init(
		date: Date,
		day: Int,
		isInMonth: Bool = false,
		events: [CalendarEvent]? = nil
	) {
		self.date = date
		self.day = day
		self.isInMonth = isInMonth
		self.isToday = Calendar.current.isDateInToday(date)
		self.isWeekend = Calendar.current.isDateInWeekend(date)
		self.events = events
	}
}

// 도메인 데이터 - 캘린더 이벤트 데이터
public struct CalendarEvent: Identifiable, Equatable, Hashable, Sendable {
	public let id = UUID()
	
	public var date: Date
	public var endDate: Date?
	
	public var title: String
	public var textColor: Color
	public var labelColor: Color
	public var notes: String
	public var location: String
	public var participants: [String]
	
	public enum ScheduleType: Sendable { case allDay, busy, free, yet, closed, secret, canceled, task, count, empty }
	public var scheduleType: ScheduleType = .yet
	
	public enum LabelType: Sendable { case event, info, padding }
	public var labelType: LabelType = .event
	
	public var rect: (Int, Int, Int, Int)
	
	public init(
		date: Date,
		endDate: Date? = nil,
		title: String,
		textColor: Color,
		labelColor: Color,
		notes: String,
		location: String,
		participants: [String],
		scheduleType: ScheduleType = .yet,
		labelType: LabelType = .event,
		rect: (Int, Int, Int, Int) = (0, 0, 0, 0)
	) {
		self.date = date
		self.endDate = endDate
		self.title = title
		self.textColor = textColor
		self.labelColor = labelColor
		self.notes = notes
		self.location = location
		self.participants = participants
		self.scheduleType = scheduleType
		self.labelType = labelType
		self.rect = rect
	}
	
	public static func == (lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
		return lhs.id == rhs.id
		&& lhs.date == rhs.date
		&& lhs.endDate == rhs.endDate
		&& lhs.title == rhs.title
		&& lhs.textColor == rhs.textColor
		&& lhs.labelColor == rhs.labelColor
		&& lhs.notes == rhs.notes
		&& lhs.location == rhs.location
		&& lhs.participants == rhs.participants
		&& lhs.scheduleType == rhs.scheduleType
		&& lhs.rect.0 == rhs.rect.0
		&& lhs.rect.1 == rhs.rect.1
		&& lhs.rect.2 == rhs.rect.2
		&& lhs.rect.3 == rhs.rect.3
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
//        hasher.combine(date)
//        hasher.combine(endDate)
//        hasher.combine(title)
//        hasher.combine(textColor)
//        hasher.combine(labelColor)
//        hasher.combine(notes)
//        hasher.combine(location)
//        hasher.combine(participants)
//        hasher.combine(scheduleType)
//        hasher.combine(rect.0)
//        hasher.combine(rect.1)
//        hasher.combine(rect.2)
//        hasher.combine(rect.3)
	}
}

public func getVisibleEventList(events: [CalendarEvent], day: CalendarDay, height: CGFloat) -> [CalendarEvent] {
	// 캘린더 셀에 해당하는 날짜의 이벤트만 필터링
	let filteredEvents = events.filter { event in
		let startDate = Calendar.current.startOfDay(for: event.date)
		let endDate = Calendar.current.startOfDay(for: (event.endDate ?? event.date))
		let limitDate = Calendar.current.date(byAdding: DateComponents(day: 1), to: endDate)!
		return startDate <= day.date && day.date < limitDate
	}.sorted { $0.rect.1 < $1.rect.1 }
	
	let count = Int(height / 16)
	var visibleEvents: [CalendarEvent] = []
	
	// 표시용 이벤트 리스트를 빈 이벤트로 초기화
	visibleEvents.append(contentsOf: (0..<count).map { row in
		CalendarEvent(
			date: day.date,
			endDate: nil,
			title: "",
			textColor: .clear,
			labelColor: .clear,
			notes: "",
			location: "",
			participants: [],
			scheduleType: .allDay,
			labelType: .padding,
			rect: (0, row, 1, 1)
		)
	})
	
	// Visible 이벤트 리스트에 이벤트 정보를 추가
	_ = filteredEvents.map { event in
		let index = event.rect.1
		if index < visibleEvents.count {
			visibleEvents[index] = event
		}
	}
	
	// 초과 카운트 레이블 추가
	if filteredEvents.count > count {
		let exceedCount = filteredEvents.count - count
		let countEvent = CalendarEvent(
			date: day.date,
			endDate: nil,
			title: "+\(exceedCount)",
			textColor: .white,
			labelColor: .gray,
			notes: "",
			location: "",
			participants: [],
			scheduleType: .count,
			labelType: .info,
			rect: (0, count - 1, 1, 1)
		)
		visibleEvents[count - 1] = countEvent
	}
	
	return visibleEvents
}

public func generateWeeks(date: Date) -> [[CalendarDay]] {
	let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
	let range = Calendar.current.range(of: .day, in: .month, for: startOfMonth)!
	let firstWeekday = Calendar.current.component(.weekday, from: startOfMonth) - Calendar.current.firstWeekday

	// 이번 달 날짜
	let days = range.map { day -> CalendarDay in
		let dayDate = Calendar.current.date(byAdding: .day, value: day - 1, to: startOfMonth)!
		return CalendarDay(date: dayDate, day: day, isInMonth: true)
	}

	// 이전 달 날짜
	let leadingEmptyDays = (firstWeekday + 7) % 7
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

	// 다음 달 날짜
	let totalCount = paddedDays.count
	let rows = Int(ceil(Double(totalCount) / 7.0))
	let needed = rows * 7
	let remaining = needed - totalCount

	if remaining > 0 {
		let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth)!
		let nextMonthDays: [CalendarDay] = (1...remaining).map { offset -> CalendarDay in
			let dayDate = Calendar.current.date(byAdding: .day, value: offset - 1, to: nextMonth)!
			return CalendarDay(date: dayDate, day: offset, isInMonth: false)
		}
		paddedDays += nextMonthDays
	}
	
	return stride(from: 0, to: paddedDays.count, by: 7).map {
		Array(paddedDays[$0..<$0.advanced(by: 7)])
	}
}
