//
//  View+Extension.swift
//  KakaoBook
//
//  Created by MK on 10/16/24.
//

import SwiftUI

/// 커스텀 스타일 정의
extension View {
	func titleStyle() -> some View {
		modifier(TitleModifier())
	}
	
	func bodyStyle() -> some View {
		modifier(ContentModifier())
	}
	
	func calloutStyle() -> some View {
		modifier(InfoModifier())
			.modifier(BlinkModifier())	// 깜빡임 추가
	}
	
	func footnoteStyle() -> some View {
		modifier(InfoModifier())
			.italic()
	}
	
	func strikeStyle() -> some View {
		modifier(InfoModifier())
			.modifier(StrikeModifier())
	}
	
	func highlightStyle() -> some View {
		modifier(InfoModifier())
			.background(.yellow)
	}
}
