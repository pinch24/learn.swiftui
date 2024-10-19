//
//  SelectCurrency.swift
//  LOTRConverter17
//
//  Created by MK on 10/18/24.
//

import SwiftUI

struct SelectCurrency: View {
	@Environment(\.dismiss) var dismiss
	@Binding var topCurrency: Currency
	@Binding var bottomCurrency: Currency
	
    var body: some View {
		ZStack {
			// Parchment background image
			Image(.parchment)
				.resizable()
				.ignoresSafeArea()
				.background(.brown)
			
			VStack {
				// Text
				Text("Select the currency you are starting with: \(Currency.copperPenny.rawValue)")
					.fontWeight(.bold)
				
				// Currency icons
				IconGrid(currency: $topCurrency)
				
				// Text
				Text("Select the currency you would like to convert to:")
					.fontWeight(.bold)
				
				// Currency icons
				IconGrid(currency: $bottomCurrency)
				
				// Done button
				Button("Done") {
					dismiss()
				}
				.buttonStyle(.borderedProminent)
				.tint(.brown)
				.font(.largeTitle)
				.padding()
				.foregroundStyle(.white)
			}
			.padding()
			.multilineTextAlignment(.center)
		}
		.onTapGesture {
			print("SelectCurrency topCurrency: \(topCurrency)")
			print("SelectCurrency bottomCurrency: \(bottomCurrency)")
		}
    }
}

#Preview {
	SelectCurrency(topCurrency: .constant(.copperPenny), bottomCurrency: .constant(.silverPiece))
}
