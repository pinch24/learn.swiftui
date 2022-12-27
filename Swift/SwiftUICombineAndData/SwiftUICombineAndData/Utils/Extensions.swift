//
//  Extensions.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/12/26.
//

import SwiftUI

extension View {
	func angularGradientGlow(colors: [Color]) -> some View {
		self.overlay(AngularGradient(gradient: Gradient(colors: colors), center: .center, angle: .degrees(0.0)))
			.mask(self)
	}
	
	func linearGradientBackground(colors: [Color]) -> some View {
		self.overlay(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
			.mask(self)
	}
	
	func blurBackground() -> some View {
		self.padding(16)
			.background(Color("Background 1"))
			.background(VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark))
			.overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.white, lineWidth: 1.0).blendMode(.overlay))
			.mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
	}
}

extension Date {
	func formatDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		dateFormatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy")
		return dateFormatter.string(from: self)
	}
}
