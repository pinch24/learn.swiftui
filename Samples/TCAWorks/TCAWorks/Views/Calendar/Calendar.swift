//
//  Calendar.swift
//  TCAWorks
//
//  Created by MK on 5/14/25.
//

import SwiftUI

public struct CalendarView: View {
	@State var selectedDate: Date = Date()
	let calendar: Calendar = Calendar.current
	let locale: Locale = Locale(identifier: "ko")

	public var body: some View {
		VStack {
			calendarHeaderView
			calendarGridView
			Spacer()
		}
		.padding()
	}
	
	// Calendar Header
	private var calendarHeaderView: some View {
		VStack {
			HStack {
				Text(monthAndYear(for: selectedDate))
					.font(.headline)
				
				Spacer()
				
				Button {
					selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
				} label: {
					Image(systemName: "chevron.left")
				}
				
				Button {
					selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
				} label: {
					Image(systemName: "chevron.right")
				}
			}
			.padding()
			
			HStack {
				ForEach(weekdaySymbols(), id: \.self) { day in
					Text(day)
						.font(.caption)
						.frame(maxWidth: .infinity)
				}
			}
		}
	}
	
	private func monthAndYear(for date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy.MM"
		formatter.locale = locale
		return formatter.string(from: date)
	}
	
	private func weekdaySymbols() -> [String] {
		var symbols = calendar.shortWeekdaySymbols
		let firstWeekdayIndex = calendar.firstWeekday - 1
		symbols = Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
		// Set Locale: "MON" -> "월"
		let koreanSymbols = symbols.map { symbol in
			let formatter = DateFormatter()
			formatter.locale = locale
			formatter.dateFormat = "E"
			return formatter.shortWeekdaySymbols[calendar.shortWeekdaySymbols.firstIndex(of: symbol)!]
		}
		return koreanSymbols
	}
	
	// Calendar Grid
	private var calendarGridView: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
			let days = generateDays(date: selectedDate)
			ForEach(Array(days.enumerated()), id: \.offset) { index, day in
				if let day {
					Text("\(day.day)")
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.padding(8)
						.background(Color.gray.opacity(0.2))
						.cornerRadius(8)
						.onTapGesture {
							selectedDate = day.date
							print("SELECTED DATE - \(day.date)")
						}
				} else {
					Text("")
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.padding(8)
				}
			}
		}
	}
	
	private func generateDays(date: Date) -> [CalendarDay?] {
		let calendar = Calendar.current
		let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
		let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
		let firstWeekday = calendar.component(.weekday, from: startOfMonth) - calendar.firstWeekday
		
		// Generate Days
		let days = range.map { day -> CalendarDay in
			let dayDate = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!
			return CalendarDay(date: dayDate, day: day)
		}
		
		// Add Empty Days
		let leadingEmptyDays = (firstWeekday + 7) % 7
		let paddedDays: [CalendarDay?] = Array(repeating: nil, count: leadingEmptyDays) + days
		return paddedDays
	}
	
	struct CalendarDay: Hashable {
		let date: Date
		let day: Int
	}
}

#if DEBUG
#Preview {
	CalendarMainPreview()
}

struct CalendarMainPreview: View {
	var body: some View {
		CalendarView()
	}
}
#endif
