//
//  Date+Extension.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import Foundation

extension Date {
	func dateFormatted(format: String) -> String {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.dateFormat = format
		return formatter.string(from: self)
	}
}
