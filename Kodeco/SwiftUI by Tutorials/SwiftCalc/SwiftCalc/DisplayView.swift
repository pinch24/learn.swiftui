//
//  DisplayView.swift
//  SwiftCalc
//
//  Created by mk on 12/10/23.
//

import SwiftUI

struct DisplayView: View {
	@Binding var display: String
	
	var body: some View {
		let _ = Self._printChanges()
		
		HStack {
			if display.isEmpty {
				Text("0")
					.accessibilityIdentifier("display")
					.padding(.horizontal, 5)
					.frame(maxWidth: .infinity, alignment: .trailing)
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(lineWidth: 2)
							.foregroundColor(Color.gray))
			}
			else {
				Text(display)
					.accessibilityIdentifier("display")
					.padding(.horizontal, 5)
					.frame(maxWidth: .infinity, alignment: .trailing)
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(lineWidth: 2)
							.foregroundColor(Color.gray))
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(lineWidth: 2)
							.foregroundColor(Color.gray))
			}
		}
		.background(Color.random)
	}
}

#Preview {
	DisplayView(display: .constant("123"))
}
