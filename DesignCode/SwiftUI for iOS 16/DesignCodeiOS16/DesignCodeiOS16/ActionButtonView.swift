//
//  ActionButtonView.swift
//  DesignCodeiOS16
//
//  Created by mk on 2023/07/23.
//

import SwiftUI

struct ActionButtonView: View {
	@State var show = false
	
    var body: some View {
		ZStack {
			Image("UI 1")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.cornerRadius(50)
			Rectangle()
				.fill(.ultraThinMaterial)
				.overlay(Rectangle().fill(.black.opacity(0.5)).blendMode(.overlay))
				.mask(canvas)
				.shadow(color: .white.opacity(0.2), radius: 0, x: -1, y: -1)
				.shadow(color: .black.opacity(0.2), radius: 0, x: 1, y: 1)
				.shadow(color: .black.opacity(0.5), radius: 10, x: 10, y: 10)
				.overlay(
					Image(systemName: "plus")
						.font(.system(size: 30))
						.foregroundColor(.white)
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
						.offset(x: -28, y: -28))
				.offset(y: -29)
				.onTapGesture {
					withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
						show.toggle()
					}
				}
		}
		.background(.black)
		.ignoresSafeArea()
		.preferredColorScheme(.dark)
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
		}
	}
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView()
    }
}
