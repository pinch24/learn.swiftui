//
//  String+Extension.swift
//  BBQuotes17
//
//  Created by MK on 10/17/24.
//

import Foundation

extension String {
	func removeSpaces() -> String {
		self.replacingOccurrences(of: " ", with: "")
	}
	
	func removeCaseAndSpace() -> String {
		self.removeSpaces().lowercased()
	}
}
