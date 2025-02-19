//
//  AnimatedMeshGradient.swift
//  Notes
//
//  Created by Mk on 2/17/25.
//

import SwiftUI

struct AnimatedMeshGradient: View {
	@State var appear = false
	@State var appear2 = false
	
	var body: some View {
		MeshGradient(
			width: 3,
			height: 3,
			points: [
				[0.0, 0.0], [appear2 ? 0.5 : 1.0, 0.0], [1.0, 0.0],
				[0.0, 0.5], appear ? [0.1, 0.5] : [0.8, 0.2], [1.0, -0.5],
				[0.0, 1.0], [1.0, appear2 ? 2.0 : 1.0], [1.0, 1.0]
			], colors: [
				appear2 ? .red : .mint, appear2 ? .yellow : .cyan, .orange,
				appear ? .blue : .red, appear ? .cyan : .white, appear ? .red : .purple,
				appear ? .red : .cyan, appear ? .mint : .blue, appear2 ? .red : .blue
			]
		)
		.onAppear {
			withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
				appear.toggle()
			}
			withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
				appear2.toggle()
			}
		}
	}
}

#Preview {
	AnimatedMeshGradient()
		.ignoresSafeArea()
}

struct AnimatedMeshGradient2: View {
	@State var t: Float = 0.0
	@State var timer: Timer?
	
	var body: some View {
		MeshGradient(width: 3, height: 3, points: [
			.init(0, 0), .init(0.5, 0), .init(1, 0),
			
			[sinInRange(-0.8...(-0.2), offset: 0.439, timeScale: 0.342, t: t), sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.984, t: t)],
			[sinInRange(0.1...0.8, offset: 0.239, timeScale: 0.084, t: t), sinInRange(0.2...0.8, offset: 5.21, timeScale: 0.242, t: t)],
			[sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.084, t: t), sinInRange(0.4...0.8, offset: 0.25, timeScale: 0.642, t: t)],
			[sinInRange(-0.8...0.0, offset: 1.439, timeScale: 0.442, t: t), sinInRange(1.4...1.9, offset: 3.42, timeScale: 0.984, t: t)],
			[sinInRange(0.3...0.6, offset: 0.339, timeScale: 0.784, t: t), sinInRange(1.0...1.2, offset: 1.22, timeScale: 0.772, t: t)],
			[sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.056, t: t), sinInRange(1.3...1.7, offset: 0.47, timeScale: 0.342, t: t)]
		], colors: [
			.blue, .red, .orange,
			.orange, .indigo, .red,
			.cyan, .purple, .mint
		])
		.onAppear {
			timer = Timer.scheduledTimer(withTimeInterval: 0.002, repeats: true) { _ in
				t += 0.02
			}
		}
		.background(.black)
		.ignoresSafeArea()
	}
	
	func sinInRange(_ range: ClosedRange<Float>, offset: Float, timeScale: Float, t: Float) -> Float {
		let amplitude = (range.upperBound - range.lowerBound) / 2
		let midPoint = (range.upperBound + range.lowerBound) / 2
		return midPoint + amplitude * sin(timeScale * t + offset)
	}
}

#Preview {
	AnimatedMeshGradient2()
}
