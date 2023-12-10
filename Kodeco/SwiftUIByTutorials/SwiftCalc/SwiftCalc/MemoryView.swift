//
//  MemoryView.swift
//  SwiftCalc
//
//  Created by mk on 12/10/23.
//

import SwiftUI

struct MemoryView: View {
	@Binding var memory: Double
	var geometry: GeometryProxy
	
	var body: some View {
		HStack {
			Spacer()
			Text("\(memory)")
				.padding(.horizontal, 5)
				.frame(
					width: geometry.size.width * 0.85,
					alignment: .trailing
				)
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.stroke(lineWidth: 2)
						.foregroundColor(Color.gray)
				)
			// Add gesture here
			Text("M")
		}.padding(.bottom).padding(.horizontal, 5)
	}
}
