//
//  ExchangeRate.swift
//  LOTRConverter17
//
//  Created by MK on 10/18/24.
//

import SwiftUI

struct ExchangeRate: View {
	let leftImage: ImageResource
	let rightImage: ImageResource
	let text: String
	
	var body: some View {
		HStack {
			// Left currency image
			Image(leftImage)
				.resizable()
				.scaledToFit()
				.frame(height: 33)
			
			// Exchange rate text
			Text(text)
			
			// Right currency image
			Image(rightImage)
				.resizable()
				.scaledToFit()
				.frame(height: 33)
		}
	}
}

#Preview {
	ExchangeRate(leftImage: .silverpiece, rightImage: .silverpenny, text: "1 Gold Piece = 4 Gold Pennies")
}
