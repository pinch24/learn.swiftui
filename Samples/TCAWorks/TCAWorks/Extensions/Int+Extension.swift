//
//  Int+Extension.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import Foundation

// Int to Date Format String
extension Int {
	func toYYYYMMString(delimiter: String = "") -> String {
		let year = self / 100
		let month = self % 100
		let formatted = String(format: "%04d\(delimiter)%02d", year, month)
		return formatted
	}
	
	func toYYYYMMDDString(delimiter: String = "") -> String {
		let year = self / 10000
		let month = (self % 10000) / 100
		let day = self % 100
		let formatted = String(format: "%04d\(delimiter)%02d\(delimiter)%02d", year, month, day)
		return formatted
	}
}
