//
//  Layout+Extension.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

//extension Layout {
	struct FlowLayout: Layout {
		var spacing: CGFloat = 8
		var lineSpacing: CGFloat = 8
		
		func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
			var size: CGSize = .zero
			var currentLineWidth: CGFloat = .zero
			var currentLineHeight: CGFloat = .zero
			let maxWidth = proposal.replacingUnspecifiedDimensions().width
			
			for subview in subviews {
				let subviewSize = subview.sizeThatFits(.unspecified)
				if currentLineWidth + subviewSize.width > maxWidth {
					size.width = max(size.width, currentLineWidth)
					size.height += currentLineHeight + lineSpacing
					currentLineWidth = subviewSize.width + spacing
					currentLineHeight = subviewSize.height
				} else {
					currentLineWidth += subviewSize.width + spacing
					currentLineHeight = max(currentLineHeight, subviewSize.height)
				}
			}
			
			size.width = max(size.width, currentLineWidth)
			size.height += currentLineHeight
			return size
		}
		
		func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
			var origin = bounds.origin
			var currentLineHeight: CGFloat = .zero
			
			for subview in subviews {
				let size = subview.sizeThatFits(.unspecified)
				if origin.x + size.width > bounds.maxX {
					origin.x = bounds.minX
					origin.y += currentLineHeight + lineSpacing
					currentLineHeight = .zero
				}
				subview.place(at: origin, proposal: ProposedViewSize(size))
				origin.x += size.width + spacing
				currentLineHeight = max(currentLineHeight, size.height)
			}
		}
	}
//}

#Preview {
	VStack {}
}
