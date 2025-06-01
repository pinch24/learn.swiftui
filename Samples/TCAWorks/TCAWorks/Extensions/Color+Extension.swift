//
//  Color+Extension.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

extension Color {
	static var random: Color {
		Color(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1)
		)
	}
}

extension Color {
	func inverted() -> Color {
		let uiColor = UIColor(self)
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
		uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
		return Color(red: 1 - r, green: 1 - g, blue: 1 - b)
	}
}

#Preview {
	Button {
		print("Button Tapped")
	} label: {
		Text("Button")
			.font(.headline)
			.foregroundColor(.random)
			.padding()
			.background(
				RoundedRectangle(cornerRadius: 16)
					.stroke(Color.secondary, lineWidth: 2)
					.background(Color.white.cornerRadius(16))
			)
	}
}
