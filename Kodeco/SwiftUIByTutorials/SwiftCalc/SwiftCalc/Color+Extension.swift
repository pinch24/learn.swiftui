//
//  Color+Extension.swift
//  SwiftCalc
//
//  Created by mk on 12/11/23.
//

import SwiftUI

extension Color {
	static var random: Color {
		return Color(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1)
		)
	}
}
