//
//  CalendarTypes.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import SwiftUI

// 날짜 타입 - 그리드 셀의 날짜를 그릴 때 사용
public struct CalendarDay: Hashable, Sendable {
	public let date: Date
	public let day: Int
	public let weekIndex: Int
	public let isInMonth: Bool
	public let isWeekend: Bool
	public let isToday: Bool
	public let isPast: Bool
	
	public init(date: Date, day: Int, isInMonth: Bool = false) {
		self.date = date
		self.day = day
		self.weekIndex = Calendar.current.component(.weekday, from: date) - 1
		self.isInMonth = isInMonth
		self.isWeekend = Calendar.current.isDateInWeekend(date)
		self.isToday = Calendar.current.isDateInToday(date)
		self.isPast = date < Calendar.current.startOfDay(for: Date())
	}
}

// 이벤트 타입 - 그리드 셀의 이벤트를 그릴 때 사용
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
	
	public enum ScheduleType: Sendable { case allDay, busy, free, closed, secret, canceled, task }
	public var scheduleType: ScheduleType = .task
	
	public enum RangeType: Sendable { case single, start, middle, end }
	public var rangeType: RangeType = .single
	
	public var rect: (Int, Int, Int, Int)
	
	public var category: String?
	
	public init(
		date: Date,
		endDate: Date? = nil,
		title: String,
		textColor: Color,
		labelColor: Color,
		notes: String,
		location: String,
		participants: [String],
		scheduleType: ScheduleType = .task,
		rangeType: RangeType = .single,
		rect: (Int, Int, Int, Int) = (0, 0, 0, 0),
		category: String? = nil
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
		self.rangeType = rangeType
		self.rect = rect
		self.category = category
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
		&& lhs.rangeType == rhs.rangeType
		&& lhs.rect.0 == rhs.rect.0
		&& lhs.rect.1 == rhs.rect.1
		&& lhs.rect.2 == rhs.rect.2
		&& lhs.rect.3 == rhs.rect.3
		&& lhs.category == rhs.category
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

public enum CalendarMode: Sendable {
	case month, week, day, schedule
	public var name: String {
		switch self {
			case .month: return "월간"
			case .week: return "주간"
			case .day: return "일간"
			case .schedule: return "일정"
		}
	}
}
