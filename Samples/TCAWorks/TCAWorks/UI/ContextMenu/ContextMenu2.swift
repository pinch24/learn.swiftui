//
//  ContextMenu2.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

public struct ContextMenu2: View {
	@Binding var show: Bool
	@Binding private var frame: CGRect
	private let actions: () -> AnyView
	
	public init(show: Binding<Bool>, frame: Binding<CGRect> = .constant(.zero), @ViewBuilder actions: @escaping () -> some View) {
		self._show = show
		self._frame = frame
		self.actions = { AnyView(actions()) }
	}
	
	public var body: some View {
		Group {
			if show {
				VStack(alignment: .leading, spacing: 8) {
					actions()
				}
			}
		}
		.tint(Color.primary)
		.padding()
		.frame(width: 144)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.stroke(Color.secondary, lineWidth: 1)
				.background(Color.white.cornerRadius(16))
		)
		.modifier(PositionModifier(frame: frame))
		.transition(.opacity)
	}
	
	// @Binding frame로 ContextMenu가 표시될 위치를 지정할 수 있다.
	public static func setFrame(_ binding: Binding<CGRect>) -> some View {
		GeometryReader { proxy in
			Color.clear
				.onAppear {
					binding.wrappedValue = proxy.frame(in: .global)
				}
				.onChange(of: proxy.frame(in: .global)) { old, new in
					binding.wrappedValue = new
				}
		}
	}
	
	// @Binding frame이 없으면 현재 위치의 오프셋으로, 있으면 설정된 위치에 표시한다.
	private struct PositionModifier: ViewModifier {
		let frame: CGRect
		func body(content: Content) -> some View {
			if frame == .zero {
				content.offset(x: -72, y: 72)
			} else {
				content.position(x: frame.minX - 54, y: frame.maxY)
			}
		}
	}
}

#Preview {
	ContextMenu2Preview()
}

struct ContextMenu2Preview: View {
	@State var show = false
	@State var frame = CGRect.zero
	
	var body: some View {
		ZStack {
			VStack {
				NavigationBar(title: "Navigation Bar", type: .menu, rightItems: [
					NavigationBarItem(iconView: AnyView(
						Button {
							show.toggle()
						} label: {
							Image(systemName: "ellipsis")
								.rotationEffect(.degrees(90))
						}.overlay(
							ContextMenu2.setFrame($frame)
						)
					))
				])
				.padding(.horizontal)
				
				Rectangle()
					.fill(Color.secondary)
					.ignoresSafeArea(.all)
			}
			
			ContextMenu2(show: $show, frame: $frame) {
				Button("이동", action: {
					print("컨텍스트 메뉴 - 이동")
				})
				Button("복사", action: {
					print("컨텍스트 메뉴 - 복사")
				})
				Button("스팸/해킹 신고", action: {
					print("컨텍스트 메뉴 - 스팸/해킹 신고")
				})
			}
		}
	}
}
