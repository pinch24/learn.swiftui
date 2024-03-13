//
//  BevelText.swift
//  RGBullsEye
//
//  Created by mk on 12/10/23.
//

import SwiftUI

struct BevelText: View {
	let text: String
	let width: CGFloat
	let height: CGFloat
	
    var body: some View {
        Text(text)
			.frame(width: width, height: height)
			.background(
				ZStack {
					Capsule()
						.fill(.element)
						.northWestShadow(radius: 3, offset: 1)
					Capsule()
						.inset(by: 3)
						.fill(.element)
						.southEastShadow(radius: 1, offset: 1)
				}
			)
    }
}

#Preview {
	ZStack {
		Color.shadow
			.ignoresSafeArea()
		BevelText(text: "RGB", width: 200, height: 48)
	}
	.frame(width: .infinity, height: 100)
	.previewLayout(.sizeThatFits)
}
