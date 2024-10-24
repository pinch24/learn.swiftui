//
//  HologramEffect.swift
//  Hologram
//
//  Created by MK on 10/24/24.
//

import SwiftUI

struct HologramEffect: AnimatableModifier {
	@Binding var progress: CGFloat
	
	var animatableData: CGFloat {
		get { progress }
		set { progress = newValue }
	}
	
	func body(content: Content) -> some View {
		content
			.scaleEffect(1.0 + progress * 0.1) // Adjust scale factor as needed
			.rotationEffect(Angle(degrees: Double(progress) * 360.0)) // Rotate the pattern
			.opacity(1.0 - progress * 0.5) // Adjust the opacity
	}
}
