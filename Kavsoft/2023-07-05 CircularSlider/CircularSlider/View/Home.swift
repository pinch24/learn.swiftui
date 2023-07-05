//
//  Home.swift
//  CircularSlider
//
//  Created by mk on 2023/07/05.
//

import SwiftUI

struct Home: View {
	@State private var pickerType: TripPicker = .scaled
	@State private var activeID: Int?
	
    var body: some View {
		VStack {
			Picker("", selection: $pickerType) {
				ForEach(TripPicker.allCases, id: \.rawValue) {
					Text($0.rawValue)
						.tag($0)
				}
			}
			.pickerStyle(.segmented)
			.padding()
			
			Spacer(minLength: 0)
			
			GeometryReader {
				let size = $0.size
				let padding = (size.width - 70) / 2
				
				ScrollView(.horizontal) {
					HStack(spacing: 35) {
						ForEach(1...8, id: \.self) { index in
							Image("Pic \(index)")
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 70, height: 70)
								.clipShape(.circle)
								.shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
								.visualEffect { view, proxy in
									view
										.offset(y: offset(proxy))
										.offset(y: scale(proxy) * 15)
								}
								.scrollTransition(.interactive, axis: .horizontal) { view, phase in
									view
										.scaleEffect(phase.isIdentity && activeID == index && pickerType == .scaled ? 1.5 : 1, anchor: .bottom)
								}
						}
					}
					.frame(height: size.height)
					.offset(y: -30)
					.scrollTargetLayout()
				}
				.background(content: {
					if pickerType == .normal {
						Circle()
							.fill(.white.shadow(.drop(color: .black.opacity(0.2), radius: 5)))
							.frame(width: 85, height: 85)
							.offset(y: -15)
					}
				})
				.safeAreaPadding(.horizontal, padding)
				.scrollIndicators(.hidden)
				.scrollTargetBehavior(.viewAligned)
				.scrollPosition(id: $activeID)
				.frame(height: size.height)
			}
			.frame(height: 200)
//			.background(Color.red)
		}
		.ignoresSafeArea(.container, edges: .bottom)
    }
	
	func offset(_ proxy: GeometryProxy) -> CGFloat {
		let progress = progress(proxy)
		return progress < 0 ? progress * -30 : progress * 30
	}
	
	func scale(_ proxy: GeometryProxy) -> CGFloat {
		let progress = min(max(progress(proxy), -1), 1)
		return progress < 0 ? 1 + progress : 1 - progress
	}
	
	func progress(_ proxy: GeometryProxy) -> CGFloat {
		let viewWidth = proxy.size.width
		let minX = (proxy.bounds(of: .scrollView)?.minX ?? 0)
		return minX / viewWidth
	}
}

#Preview {
    Home()
}

// Slider Type
enum TripPicker: String, CaseIterable {
	case scaled = "Scaled"
	case normal = "Normal"
}
