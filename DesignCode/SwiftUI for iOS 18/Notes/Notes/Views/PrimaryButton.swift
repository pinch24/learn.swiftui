//
//  PrimaryButton.swift
//  Notes
//
//  Created by Mk on 2/18/25.
//

import SwiftUI

struct PrimaryButton: View {
	let title: String
	let icon: String
	let isLoading: Bool
	let isDisabled: Bool
	let action: () -> Void
	
	init(
		title: String,
		icon: String = "sparkles",
		isLoading: Bool = false,
		isDisabled: Bool = false,
		action: @escaping () -> Void
	) {
		self.title = title
		self.icon = icon
		self.isLoading = isLoading
		self.isDisabled = isDisabled
		self.action = action
	}
	
	// Ripple animation vars
	@State var counter: Int = 0
	@State var origin: CGPoint = .init(x: 0.5, y: 0.5)
	@State private var isRotating = false
	
	var body: some View {
		Button(action: action) {
			HStack {
				if isLoading {
					Image(systemName: "progress.indicator")
						.rotationEffect(.degrees(isRotating ? 360 : 0))
						.animation(
							.linear(duration: 1)
							.repeatForever(autoreverses: false),
							value: isRotating
						)
						.onAppear {
							isRotating = true
						}
				} else {
					Image(systemName: icon)
				}
				Text(isLoading ? "Generating..." : title)
			}
			.frame(maxWidth: .infinity)
			.foregroundColor(.white)
		}
		.tint(.primary)
		.controlSize(.large)
		.frame(height: 50)
		.background(
			ZStack {
				if !isDisabled {
					AnimatedMeshGradient()
						.mask(
							RoundedRectangle(cornerRadius: 16, style: .continuous)
								.stroke(lineWidth: 16)
								.blur(radius: 8)
						)
					
						.overlay(
							RoundedRectangle(cornerRadius: 16)
								.stroke(lineWidth: 3)
								.fill(Color.white)
								.blur(radius: 2)
								.blendMode(.overlay)
						)
						.overlay(
							RoundedRectangle(cornerRadius: 16)
								.stroke(lineWidth: 1)
								.fill(Color.white)
								.blur(radius: 1)
								.blendMode(.overlay)
						)
				}
			}
		)
		.background(
			ZStack {
				AnimatedMeshGradient()
					.frame(width: 400, height: 800)
					.opacity(isLoading ? 1 : 0)
			}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
		)
		.background(.black)
		.clipShape(RoundedRectangle(cornerRadius: 16))
		.background(
			RoundedRectangle(cornerRadius: 16)
				.stroke(.primary.opacity(0.5), lineWidth: 1)
		)
		.shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20)
		.shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 15)
		.opacity(isDisabled ? 0.5 : 1)
		.onPressingChanged { point in
			if let point {
				origin = point
				counter += 1
			}
		}
		.modifier(RippleEffect(at: origin, trigger: counter))
	}
}

#Preview {
	PrimaryButton(title: "Generate Notes", isLoading: false, action: {})
		.padding(40)
}
