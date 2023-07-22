//
//  RadialLayoutView.swift
//  DesignCodeiOS16
//
//  Created by mk on 2023/07/22.
//

import SwiftUI

struct RadialLayoutView: View {
	var icons = ["calendar", "message", "figure.walk", "music.note"]
	
    var body: some View {
		CustomLayout {
			ForEach(icons, id: \.self) { item in
				Circle()
					.frame(width: 44)
					.foregroundColor(.black)
					.overlay(Image(systemName: item).foregroundColor(.white))
			}
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
