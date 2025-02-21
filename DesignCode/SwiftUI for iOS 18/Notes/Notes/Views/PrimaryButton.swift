//
//  PrimaryButton.swift
//  Notes
//
//  Created by Mk on 2/18/25.
//

import SwiftUI

struct PrimaryButton: View {
	var isLoading: Bool = false
	var isDisabled: Bool = false
	var action: () -> Void = {}
	@State var counter: Int = 0
	@State var origin: CGPoint = .zero
	
	var body: some View {
		Button(action: action) {
			HStack {
				if isLoading {
					LoadingIndicator()
				} else {
					Image(systemName: "sparkles")
				}
				Text(isLoading ? "Generating..." : "Generate Notes")
			}
			.padding()
			.frame(maxWidth: .infinity)
		}
		.background(
			ZStack {
				if !isDisabled {
					AnimatedMeshGradient()
						.mask(
							RoundedRectangle(cornerRadius: 16)
								.stroke(lineWidth: 16)
								.blur(radius: 8)
						)
						.overlay(
							RoundedRectangle(cornerRadius: 16)
								.stroke(.white, lineWidth: 3)
								.blur(radius: 2)
								.blendMode(.overlay)
						)
						.overlay(
							RoundedRectangle(cornerRadius: 16)
								.stroke(.white, lineWidth: 1)
								.blur(radius: 1)
								.blendMode(.overlay)
						)
				}
			}
		)
		.background(.black)
		.cornerRadius(16)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.stroke(.black.opacity(0.5), lineWidth: 1)
		)
		.shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20)
		.shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 15)
		.foregroundColor(.white)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.stroke(.primary.opacity(0.5), lineWidth: 1)
		)
		.disabled(isLoading || isDisabled)
		.opacity(isDisabled ? 0.5 : 1)
		.onPressingChanged { point in
			if !isDisabled {
				if let point {
					origin = point
					counter += 1
				}
			}
		}
		.modifier(RippleEffect(at: origin, trigger: counter))
	}
}

struct LoadingIndicator: View {
	@State private var isAnimating = false

	var body: some View {
		Circle()
			.trim(from: 0, to: 0.7)
			.stroke(Color.white, lineWidth: 2)
			.frame(width: 16, height: 16)
			.rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
			.onAppear {
				withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
					isAnimating = true
				}
			}
	}
}


#Preview {
	PrimaryButton()
}
