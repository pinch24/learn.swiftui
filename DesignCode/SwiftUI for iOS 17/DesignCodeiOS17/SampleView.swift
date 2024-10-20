//
//  SampleView.swift
//  DesignCodeiOS17
//
//  Created by MK on 10/20/24.
//

import SwiftUI

struct SampleView: View {
	@State private var animate = false  // 애니메이션을 트리거할 상태
	
	var body: some View {
		VStack {
			Image(systemName: "bell.and.waves.left.and.right.fill")
				.symbolEffect(.bounce, options: .speed(3).repeat(3), value: animate ? 1 : 0)
				.font(.system(size: 100))  // 심볼 크기
				.padding()
			
			// 버튼을 눌러 애니메이션 트리거
			Button("Animate") {
				animate.toggle()  // 상태 변경으로 애니메이션 트리거
			}
		}
	}
}

#Preview {
	SampleView()
}
