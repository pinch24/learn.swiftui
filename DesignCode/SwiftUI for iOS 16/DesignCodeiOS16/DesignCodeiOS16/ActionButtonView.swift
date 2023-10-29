//
//  ActionButtonView.swift
//  DesignCodeiOS16
//
//  Created by mk on 2023/07/23.
//

import SwiftUI

struct ActionButtonView: View {
	@State var show = false
	@State var translation: CGSize = .zero
	
	var drag: some Gesture {
		DragGesture()
			.onChanged { value in
				translation = value.translation
			}
			.onEnded { value in
				withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
					translation = .zero
				}
			}
	}
	
    var body: some View {
		ZStack {
			Image("UI 1")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.cornerRadius(50)
				.scaleEffect(show ? 0.95 : 1)
			Rectangle()
				.fill(.ultraThinMaterial)
				.overlay(Rectangle().fill(.black.opacity(0.5)).blendMode(.overlay))
				.mask(canvas)
				.shadow(color: .white.opacity(0.2), radius: 0, x: -1, y: -1)
				.shadow(color: .black.opacity(0.2), radius: 0, x: 1, y: 1)
				.shadow(color: .black.opacity(0.5), radius: 10, x: 10, y: 10)
				.overlay(icons)
				.background(
					circle
						.frame(width: 208)
						.overlay(circle.frame(width: 60))
						.overlay(circle.frame(width: 80))
						.offset(x: 60, y: 60)
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
						.opacity(show ? 1 : 0)
						.scaleEffect(show ? 1 : 0.8, anchor: .bottomTrailing)
						.animation(.easeOut(duration: 0.3), value: show))
				.offset(y: -29)
				.onTapGesture {
					withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
						show.toggle()
					}
				}
				.gesture(drag)
		}
		.background(.black)
		.ignoresSafeArea()
		.preferredColorScheme(.dark)
    }
	
	var circle: some View {
		Circle().stroke().fill(.linearGradient(colors: [.white.opacity(0.5), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
	}
	
	var icons: some View {
		ZStack {
			Image(systemName: "plus")
				.font(.system(size: 30))
				.rotationEffect(.degrees(show ? 45: 0))
				.offset(x: -28, y: -28)
			Group {
				Image(systemName: "bubble.left.fill")
					.offset(x: -28, y: -129)
				Image(systemName: "moon.fill")
					.offset(x: -128, y: -29)
				Image(systemName: "quote.opening")
					.offset(x: -113, y: -114)
			}
			.opacity(show ? 1 : 0)
			.blur(radius: show ? 0 : 10)
			.scaleEffect(show ? 1 : 0.5)
		}
		.foregroundColor(.white)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
	}
	
	var canvas: some View {
		Canvas { context, size in
			context.addFilter(.alphaThreshold(min: 0.8))
			context.addFilter(.blur(radius: 10))
			context.drawLayer { ctx in
				for index in 1...4 {
					if let symbol = context.resolveSymbol(id: index) {
						ctx.draw(symbol, at: CGPoint(x: size.width - 44, y: size.height - 44))
					}
				}
			}
		} symbols: {
			Circle()
				.frame(width: 76)
				.tag(1)
			Circle()
				.frame(width: 76)
				.tag(2)
				.offset(x: show ? -100 : 0)
			Circle()
				.frame(width: 76)
				.tag(3)
				.offset(y: show ? -100 : 0)
			Circle()
				.frame(width: 76)
				.tag(4)
				.offset(x: show ? -84 : 0, y: show ? -84 : 0)
			Circle()
				.frame(width: 76)
				.tag(5)
				.offset(translation)
		}
	}
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView()
    }
}
