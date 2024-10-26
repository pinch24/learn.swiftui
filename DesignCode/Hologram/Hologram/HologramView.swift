//
//  HologramView.swift
//  Hologram
//
//  Created by MK on 10/24/24.
//

import SwiftUI

struct HologramView: View {
	@State private var animationProgress: CGFloat = 0.0
	
	var body: some View {
		HologramShape()
			.stroke(style: StrokeStyle(lineWidth: 1, lineJoin: .round))
			.foregroundColor(.blue)
			.opacity(0.8)
			.onTapGesture {
				withAnimation {
					self.animationProgress = self.animationProgress == 0.0 ? 1.0 : 0.0
				}
			}
			.modifier(HologramEffect(progress: $animationProgress))
	}
}

#Preview {
	HologramView()
}
