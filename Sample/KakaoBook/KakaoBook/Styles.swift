//
//  Styles.swift
//  KakaoBook
//
//  Created by MK on 10/16/24.
//

import SwiftUI

/// 타이틀 텍스트
struct TitleModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.largeTitle)
			.fontWeight(.bold)
			.foregroundColor(.orange)
	}
}

/// 컨텐트 텍스트
struct ContentModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.body)
			.fontWeight(.regular)
			.foregroundColor(.primary)
	}
}

/// 설명 텍스트
struct InfoModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.callout)
			.fontWeight(.medium)
			.foregroundColor(.secondary)
	}
}

/// 아이템 텍스트
struct ItemModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.footnote.weight(.semibold))
			.foregroundColor(.secondary)
	}
}

/// 지움 텍스트
struct StrikeModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.strikethrough(true, color: .gray)
	}
}

/// 깜빡임 텍스트
struct BlinkModifier: ViewModifier {
	@State private var isVisible = false
	let duration: Double = 0.8
	let repeatCount: Int = .max
	
	func body(content: Content) -> some View {
		content
			.opacity(isVisible ? 1 : 0)
			.onAppear {
				withAnimation(Animation.easeInOut(duration: duration)
					.repeatCount(repeatCount, autoreverses: true)) {
					isVisible.toggle()
				}
			}
	}
}
