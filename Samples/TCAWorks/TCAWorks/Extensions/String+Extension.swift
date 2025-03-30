//
//  String+Extension.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import Foundation

extension String {
	var isValidEmail: Bool {
		let pattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
		return self.wholeMatch(of: pattern) != nil
	}
}
