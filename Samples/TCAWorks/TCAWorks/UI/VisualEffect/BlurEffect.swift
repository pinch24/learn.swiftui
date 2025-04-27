//
//  BlurEffect.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

public struct BlurEffect: View {
	public var color = Color.secondary
	public var opacity = 0.64
	public var contentOpacity = 0.92
	
	public var body: some View {
		ZStack {
			Rectangle()
				.fill(.ultraThinMaterial)
				.ignoresSafeArea(edges: .top)
			color.opacity(opacity)
				.ignoresSafeArea(edges: .top)
		}.opacity(contentOpacity)
	}
}

#Preview {
	BlurEffectPreview()
}

private struct BlurEffectPreview: View {
	var body : some View {
		ZStack {
			Color.gray.edgesIgnoringSafeArea(.all)
				.zIndex(0)
			
			VStack {
				Color.clear.frame(height: 44)
				
				Text("Blur Effect")
					.frame(height: 44)
					.frame(maxWidth: .infinity)
					.background(BlurEffect())
				
				Spacer()
			}
			.zIndex(2)
			
			ScrollView {
				Color.clear.frame(height: 88 + 16)
				
				ForEach(0..<20, id: \.self) { _ in
					Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
						.foregroundStyle(Color.white)
						.background(Color(
							red: .random(in: 0...1),
							green: .random(in: 0...1),
							blue: .random(in: 0...1)
						))
						
				}
			}
			.zIndex(1)
			
			VStack {
				Spacer()
				
				Image(systemName: "magnifyingglass")
					.frame(maxWidth: .infinity)
					.frame(height: 88)
					.background(BlurEffect(color: .green, opacity: 0.4, contentOpacity: 0.8))
			}
			.zIndex(3)
		}
		.ignoresSafeArea()
	}
}
