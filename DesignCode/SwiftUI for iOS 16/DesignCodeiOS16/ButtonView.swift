//
//  ButtonView.swift
//  DesignCodeiOS16
//
//  Created by MK on 10/23/24.
//

import SwiftUI

struct ButtonView: View {
	@State var appear = false
	@GestureState var isPressed = false
	@State var show = false
	
	var longPress: some Gesture {
		LongPressGesture(minimumDuration: 1)
			.updating($isPressed) { currentState, gestureState, transaction in
				gestureState = currentState
			}
			.onEnded { _ in
				show.toggle()
			}
	}
	
	var body: some View {
		RoundedRectangle(cornerRadius: 30)
			.frame(width: 64, height: 44)
			.foregroundStyle(
				isPressed ?
				LinearGradient(colors: [Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1)), Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
					.shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
					.shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
					.shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
				:
					LinearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
					.shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
					.shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
					.shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
			)
			.overlay(
				ZStack {
					RoundedRectangle(cornerRadius: 30)
						.stroke(.black, lineWidth: 1)
					RoundedRectangle(cornerRadius: 30)
						.trim(from: isPressed ? 0 : 1, to: isPressed ? 1 : 0)
						.stroke(.white, lineWidth: 3)
						.blendMode(.overlay)
						.animation(.easeOut(duration: 0.5), value: isPressed)
					RoundedRectangle(cornerRadius: 30)
						.stroke(.white, lineWidth: 3)
						.blendMode(.overlay)
						.opacity(show ? 1 : 0)
				})
			.overlay(Image(systemName: "circle").foregroundStyle(.white))
			.background(
				ZStack {
					AngularGradient(colors: [.red, .blue, .teal, .red], center: .center)
						.cornerRadius(30)
						.blur(radius: 15)
					AngularGradient(colors: [.white, .blue, .teal, .white], center: .center, angle: .degrees(appear ? 360 : 0))
						.cornerRadius(30)
						.blur(radius: 15)
						.blendMode(.overlay)
				}
				.opacity(show ? 1 : 0))
			.scaleEffect(isPressed ? 1.1 : 1)
			.animation(.spring(response: 0.6, dampingFraction: 0.4), value: isPressed)
			.gesture(longPress)
			.onAppear {
				withAnimation(.linear(duration: 2).repeatCount(10, autoreverses: false)) {
					appear = true
				}
			}
	}
}

#Preview {
	ZStack {
		Image("Wallpaper 3").blur(radius: 100)
		ButtonView()
	}
	.preferredColorScheme(.dark)
}
