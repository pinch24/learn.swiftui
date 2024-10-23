//
//  TooltipView.swift
//  DesignCodeiOS16
//
//  Created by MK on 10/23/24.
//

import SwiftUI

struct TooltipView: View {
	@State var appear = false
	
    var body: some View {
		VStack {
			symbol
				.overlay(symbol.blur(radius: 12))
				.padding(12)
			Text("Retrace Steps")
				.fontWeight(.medium)
				.frame(maxWidth: .infinity)
				.padding(12)
				.background(.linearGradient(colors: [.white.opacity(0.1), .white.opacity(0.05)], startPoint: .top, endPoint: .bottom))
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(lineWidth: 2)
						.fill(.linearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom)))
				.cornerRadius(10)
			Text("Delete Steps")
				.fontWeight(.semibold)
				.blendMode(.overlay)
				.frame(maxWidth: .infinity)
				.padding(12)
				.background(.linearGradient(colors: [.white.opacity(0.1), .white.opacity(0.05)], startPoint: .top, endPoint: .bottom))
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(lineWidth: 2)
						.fill(.linearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom)))
				.cornerRadius(10)
		}
		.frame(width: 240)
		.padding(20)
		.background(.ultraThinMaterial)
		.background(.black.blendMode(.overlay))
		.cornerRadius(20)
		.overlay(
			ZStack {
				RoundedRectangle(cornerRadius: 20)
					.stroke(lineWidth: 1)
					.fill(.angularGradient(colors: [.white, .clear, .clear, .clear, .clear, .white], center: .center, startAngle: .degrees(60), endAngle: .degrees(360)))
					.blendMode(.overlay)
				RoundedRectangle(cornerRadius: 20)
					.stroke(lineWidth: 1)
					.fill(.angularGradient(colors: [.white, .clear, .clear, .clear, .clear, .white], center: .center, startAngle: .degrees(180), endAngle: .degrees(360)))
					.blendMode(.overlay)
			})
		.background(
			ZStack {
				AngularGradient(colors: [.teal, .white.opacity(0.5), .clear, .teal], center: .center, angle: .degrees(appear ? 120 : 0))
					.blur(radius: 15)
				AngularGradient(colors: [.purple, .white.opacity(0.5), .clear, .purple], center: .center, angle: .degrees(appear ? 120 : 0))
					.blur(radius: 15)
			})
		.onAppear {
			withAnimation(.linear(duration: 2).repeatCount(100, autoreverses: true)) {
				appear = true
			}
		}
    }
	
	var symbol: some View {
		Image(systemName: "point.3.connected.trianglepath.dotted")
			.font(.system(size: 64))
			.fontWeight(.ultraLight)
			.foregroundStyle(.angularGradient(colors: [.red, .blue, .teal, .red], center: .center, startAngle: .degrees(0), endAngle: .degrees(360)))
	}
}

#Preview {
    TooltipView()
		.preferredColorScheme(.dark)
		.background(Image("Wallpaper 3").blur(radius: 100))
}
