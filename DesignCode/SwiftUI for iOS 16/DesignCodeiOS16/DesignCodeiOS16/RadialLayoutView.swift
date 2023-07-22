//
//  RadialLayoutView.swift
//  DesignCodeiOS16
//
//  Created by mk on 2023/07/22.
//

import SwiftUI

struct RadialLayoutView: View {
	var icons = ["calendar", "message", "figure.walk", "music.note",]
	var numbers = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
	
    var body: some View {
		ZStack {
			RadialLayout {
				ForEach(icons, id: \.self) { item in
					Circle()
						.frame(width: 44)
						.foregroundColor(.black)
						.overlay(Image(systemName: item).foregroundColor(.white))
				}
			}.frame(width:120)
			
			RadialLayout {
				ForEach(numbers, id: \.self) { item in
					Text(item.description)
						.font(.system(.title, design: .rounded).bold())
						.foregroundColor(.black)
				}
			}
			.frame(width: 240)
			
			RadialLayout {
				ForEach(numbers, id: \.self) { item in
					Text("\(item * 5)")
						.font(.system(.caption, design: .rounded).bold())
						.foregroundColor(.black)
				}
			}
			.frame(width: 360)
			
			Circle()
				.strokeBorder(style: StrokeStyle(lineWidth: 10, dash: [1, 10]))
				.frame(width: 220)
		}
    }
}

struct RadialLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        RadialLayoutView()
    }
}

struct CustomLayout: Layout {
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		proposal.replacingUnspecifiedDimensions()
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		for (index, subview) in subviews.enumerated() {
			var point = CGPoint(x: 50 * index, y: 50 * index).applying(CGAffineTransform(rotationAngle: 5))
			point.x += bounds.midX
			point.y += bounds.midY
			subview.place(at: point, anchor: .center, proposal: .unspecified)
		}
	}
}

struct RadialLayout: Layout {
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		proposal.replacingUnspecifiedDimensions()
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		
		let radius = bounds.width / 3.0
		let angle = Angle.degrees(360.0 / Double(subviews.count)).radians
		
		for (index, subview) in subviews.enumerated() {
			var point = CGPoint(x: 0, y: -radius).applying(CGAffineTransform(rotationAngle: angle * Double(index)))
			point.x += bounds.midX
			point.y += bounds.midY
			subview.place(at: point, anchor: .center, proposal: .unspecified)
		}
	}
}
