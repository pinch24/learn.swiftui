//
//  Date+Extension.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import Foundation

extension Date {
	// Date to String
	func toString(format: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatter.locale = Locale(identifier: "ko")
		return formatter.string(from: self)
	}
	
	// Date to Int
	func toInt(format: String) -> Int {
		let string = self.toString(format: format)
		return Int(string) ?? 0
	}
	
	// String to Date
	public static func from(_ string: String, format: String = "yyyy.MM.dd") -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
		return formatter.date(from: string) ?? Date()
	}
	
	// Int to Date
	public static func from(_ value: Int, format: String = "yyyyMMdd") -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
		return formatter.date(from: String(value)) ?? Date()
	}
	
	// NOTE: Date 인스턴스가 필요한 연산이 아니지만, 기능 그룹으로 Date에 포함
	public static func getWeekday() -> [String] {
		// return ["일", "월", "화", "수", "목", "금", "토"]
		var symbols = Calendar.current.shortWeekdaySymbols
		let firstWeekdayIndex = Calendar.current.firstWeekday - 1
		symbols = Array(symbols[firstWeekdayIndex...] + symbols[..<firstWeekdayIndex])
		// Set Locale: "MON" -> "월"
		let koreanSymbols = symbols.map { symbol in
			let formatter = DateFormatter()
			formatter.locale = Locale(identifier: "ko")
			formatter.dateFormat = "E"
			return formatter.shortWeekdaySymbols[Calendar.current.shortWeekdaySymbols.firstIndex(of: symbol)!]
		}
		return koreanSymbols
	}
	
	// 날짜가 포함된 주의 첫번째 날짜
	var startOfWeek: Date {
		Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
	}
}
