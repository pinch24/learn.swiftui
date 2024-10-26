//
//  CardView.swift
//  Hologram
//
//  Created by MK on 10/26/24.
//

import SwiftUI

struct CardView: View {
	var body: some View {
		ZStack {
			Color.black.edgesIgnoringSafeArea(.all)

			VStack(alignment: .leading) {
				Text("Debit Card")
					.font(.headline)
					.foregroundColor(.white)
				Text("**** 0941")
					.font(.body)
					.foregroundColor(.white)
				Spacer()
				HStack {
					Text("Valid Thru 06/05")
						.font(.caption)
						.foregroundColor(.white)
					Spacer()
					Image(systemName: "applelogo")
						.font(.system(size: 40))
						.foregroundColor(.white)
				}
			}
			.padding(30)
			.frame(width: 360, height: 240)
			.background(gradientBackground)
			.cornerRadius(30)
			.overlay(RoundedRectangle(cornerRadius: 30).strokeBorder(gradientOutline, lineWidth: 2))
		}
	}

	var gradientBackground: some View {
		LinearGradient(gradient: Gradient(colors: [Color(hex: "#8E5AF7"), Color(hex: "#5D11F7")]), startPoint: .topLeading, endPoint: .bottomTrailing)
	}

	var gradientOutline: LinearGradient {
		LinearGradient(gradient: Gradient(stops: [
			Gradient.Stop(color: Color.white.opacity(0.5), location: 0),
			Gradient.Stop(color: Color.clear, location: 0.5),
			Gradient.Stop(color: Color.white.opacity(0.5), location: 1)
		]), startPoint: .topLeading, endPoint: .bottomTrailing)
	}
}

extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3:
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6:
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8:
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (1, 1, 1, 0)
		}
		self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
	}
}

#Preview {
	CardView()
}
