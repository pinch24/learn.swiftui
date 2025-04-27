//
//  View+Extension.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

extension View {
	@ViewBuilder
	func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}

#Preview {
    View_Preview()
}

struct View_Preview: View {
	@State private var isHidden = false
	var body: some View {
		HStack {
			Button {
				print("Button 1 Tapped")
				isHidden.toggle()
			} label: {
				Text("Button 1")
					.font(.headline)
					.foregroundColor(.primary)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 16)
							.stroke(Color.primary, lineWidth: 2)
							.background(Color.white.cornerRadius(16))
					)
			}
			.if(isHidden) { view in
				view.hidden()
			}
			
			Button {
				print("Button 2 Tapped")
				isHidden.toggle()
			} label: {
				Text("Button 2")
					.font(.headline)
					.foregroundColor(.secondary)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 16)
							.stroke(Color.secondary, lineWidth: 2)
							.background(Color.white.cornerRadius(16))
					)
			}
		}
	}
}
