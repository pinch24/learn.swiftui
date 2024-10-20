//
//  ContentView.swift
//  DesignCodeiOS17
//
//  Created by mk on 2023/06/19.
//

import SwiftUI

struct ContentView: View {
	@State var isActive = false
	@State var isTapped = false
	@State var isDownloading = false
	@State var time = Date.now
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	struct AnimationValues {
		var position = CGPoint(x: 0, y: 0)
		var scale = 1.0
	}
	
	var body: some View {
		ZStack {
			Image(.image1)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(height: isTapped ? 600 : 300)
				.frame(width: isTapped ? 402 : 360)
				.cornerRadius(isTapped ? 0 : 20)
				.overlay(
					RoundedRectangle(cornerRadius: 20)
						.strokeBorder(linearGradient)
						.opacity(isTapped ? 0 : 1))
				.offset(y: isTapped ? -200 : 0)
				.phaseAnimator([1, 2], trigger: isTapped) { content, phase in
					content.blur(radius: phase == 2 ? 100 : 0)
				}
			
			Circle()
				.fill(.thinMaterial)
				.frame(width: 100)
				.overlay(Circle().stroke(.secondary))
				.overlay(Image(systemName: "photo").font(.largeTitle))
				.offset(y: -150)
				.keyframeAnimator(initialValue: AnimationValues(), trigger: isDownloading) { content, value in
					content.offset(x: value.position.x, y: value.position.y)
						.scaleEffect(value.scale)
				} keyframes: { value in
					KeyframeTrack(\.position) {
						SpringKeyframe(CGPoint(x: 100, y: -100), duration: 0.5, spring: .bouncy)
						CubicKeyframe(CGPoint(x: 400, y: 1000), duration: 0.5)
					}
					KeyframeTrack(\.scale) {
						CubicKeyframe(1.2, duration: 0.5)
						CubicKeyframe(1, duration: 0.5)
					}
				}
			
			content
				.padding(20)
				.background(.regularMaterial)
				.overlay(
					RoundedRectangle(cornerRadius: 20)
						.strokeBorder(linearGradient))
				.cornerRadius(20)
				.padding(40)
				.offset(y: isTapped ? 220 : 80)
				.phaseAnimator([1, 1.1], trigger: isTapped) { content, phase in
					content.scaleEffect(phase)
				} animation: { phase in
					switch phase {
					case 1: .bouncy
					case 1.1: .easeOut(duration: 1)
					default: .easeInOut
					}
				}
			
			play
				.frame(width: isTapped ? 220 : 50)
				.foregroundStyle(.primary, .white)
				.font(.largeTitle)
				.padding(20)
				.background(.ultraThinMaterial)
				.overlay(
					RoundedRectangle(cornerRadius: 20)
						.strokeBorder(linearGradient))
				.cornerRadius(20)
				.offset(y: isTapped ? 40 : -44)
			
		}
		.frame(maxWidth: 400)
		.dynamicTypeSize(.xSmall ... .xxLarge)
	}
	
	var linearGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [.clear, .primary.opacity(0.3), .clear]), startPoint: .topLeading, endPoint: .bottomTrailing)
	}
	
	var content: some View {
		VStack(alignment: .center) {
			Text("modern architecture, an isometric tiny house, cute illustration, minimalist, vector art, night view")
				.font(.subheadline)
			HStack(spacing: 8.0) {
				VStack(alignment: .leading) {
					Text("Size")
						.foregroundColor(Color.secondary)
					Text("1024x1024")
				}
				.font(.subheadline)
				.fontWeight(.semibold)
				
				Divider()
				
				VStack(alignment: .leading) {
					Text("Type")
						.foregroundColor(.secondary)
					Text("Upscale")
				}
				.font(.subheadline)
				.fontWeight(.semibold)
				
				Divider()
				
				VStack(alignment: .leading) {
					Text("Date")
						.foregroundColor(.secondary)
					Text("Today 5:19")
				}
				.font(.subheadline)
				.fontWeight(.semibold)
			}
			.frame(height: 44)
			
			HStack {
				HStack {
					Image(systemName: "ellipsis")
						.symbolEffect(.pulse)
					Divider()
					Image(systemName: "sparkle.magnifyingglass")
						.symbolEffect(.scale.up, isActive: isActive)
					Divider()
					Image(systemName: "face.smiling")
						.symbolEffect(.appear, isActive: isActive)
				}
				.padding()
				.frame(height: 44)
				.overlay(
					UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 20, bottomTrailing: 0, topTrailing: 20))
						.strokeBorder(linearGradient))
				.offset(x: -20, y: 20)
				
				Spacer()
				
				Image(systemName: "square.and.arrow.down")
					.padding()
					.frame(height: 44)
					.overlay(
						UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 20, bottomLeading: 0, bottomTrailing: 20, topTrailing: 0))
							.strokeBorder(linearGradient))
					.offset(x: 20, y: 20)
					.symbolEffect(.bounce, value: isDownloading)
					.onTapGesture {
						isDownloading.toggle()
					}
			}
		}
	}
	
	var play: some View {
		HStack(spacing: 30) {
			Image(systemName: "wand.and.rays")
				.frame(width: 44)
				.symbolEffect(.variableColor.iterative.reversing, options: .speed(3))
				.symbolEffect(.bounce, value: isTapped)
				.opacity(isTapped ? 1 : 0)
				.blur(radius: isTapped ? 0 : 20)
			Image(systemName: isTapped ? "pause.fill" : "play.fill")
				.frame(width: 44)
				.contentTransition(.symbolEffect(.replace))
				.onTapGesture {
					withAnimation(.bouncy) {
						isTapped.toggle()
					}
				}
			Image(systemName: "bell.and.waves.left.and.right.fill")
				.frame(width: 44)
				.symbolEffect(.bounce, options: .speed(3).repeat(3), value: isTapped)
				.opacity(isTapped ? 1 : 0)
				.blur(radius: isTapped ? 0 : 20)
				.onReceive(timer) { value in
					time = value
					isActive.toggle()
				}
		}
	}
}

#Preview {
	ContentView()
}
