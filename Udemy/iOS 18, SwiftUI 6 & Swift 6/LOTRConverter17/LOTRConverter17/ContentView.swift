//
//  ContentView.swift
//  LOTRConverter17
//
//  Created by MK on 10/14/24.
//

import SwiftUI
import TipKit

struct ContentView: View {
	@State var showExchangeInfo = false
	@State var showSelectedCurrency = false
	
	@State var leftAmount = ""
	@State var rightAmount = ""
	
	@FocusState var leftTyping
	@FocusState var rightTyping
	
	@State var leftCurrency: Currency = .silverPiece
	@State var rightCurrency: Currency = .goldPiece
	
    var body: some View {
        ZStack {
            // Background Image
			Image(.background)
				.resizable()
				.ignoresSafeArea()
			
			VStack {
				// Prancing pony image
				Image(.prancingpony)
					.resizable()
					.scaledToFit()
					.frame(height: 200)
				
				// Currency exchange text
				Text("Currency Exchange")
					.font(.largeTitle)
					.foregroundStyle(.white)
				
				// Currency conversion section
				
				HStack {
					// Left conversion section
					VStack {
						// Currency
						HStack {
							// Currency image
							Image(leftCurrency.image)
								.resizable()
								.scaledToFit()
								.frame(height: 33)
							
							// Currency text
							Text(leftCurrency.name)
								.font(.headline)
								.foregroundStyle(.white)
						}
						.padding(.bottom, -5)
						.onTapGesture {
							showSelectedCurrency.toggle()
						}
						.popoverTip(CurrencyTip(), arrowEdge: .bottom)
						
						// Textfield
						TextField("Amount", text: $leftAmount)
							.textFieldStyle(.roundedBorder)
							.focused($leftTyping)
							.keyboardType(.decimalPad)
					}
					
					// Equal sign
					Image(systemName: "equal")
						.font(.largeTitle)
						.foregroundStyle(.white)
						.symbolEffect(.pulse)
					
					// Right conversion section
					VStack {
						// Currency
						HStack {
							// Currency text
							Text(rightCurrency.name)
								.font(.headline)
								.foregroundStyle(.white)
							
							// Currency image
							Image(rightCurrency.image)
								.resizable()
								.scaledToFit()
								.frame(height: 33)
						}
						.padding(.bottom, -5)
						.onTapGesture {
							showSelectedCurrency.toggle()
						}
						
						// Textfield
						TextField("Amount", text: $rightAmount)
							.textFieldStyle(.roundedBorder)
							.multilineTextAlignment(.trailing)
							.focused($rightTyping)
							.keyboardType(.decimalPad)
					}
				}
				.padding()
				.background(.black.opacity(0.5))
				.clipShape(.capsule)
				
				Spacer()
				
				// Info button
				HStack {
					Spacer()
					
					Button {
						showExchangeInfo.toggle()
						print("showExchangeInfo value: \(showExchangeInfo)")
					} label: {
						Image(systemName: "info.circle.fill")
					}
					.font(.largeTitle)
					.foregroundStyle(.white)
					.padding(.trailing)
				}
			}
        }
		.task {
			try? Tips.configure()
		}
		.onChange(of: leftAmount) { _, amount in
			if leftTyping {
				rightAmount = leftCurrency.convert(amount, to: rightCurrency)
			}
		}
		.onChange(of: rightAmount) { _, amount in
			if rightTyping {
				leftAmount = rightCurrency.convert(amount, to: leftCurrency)
			}
		}
		.onChange(of: leftCurrency) {
			leftAmount = rightCurrency.convert(rightAmount, to: leftCurrency)
		}
		.onChange(of: rightCurrency, {
			rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
		})
		.sheet(isPresented: $showExchangeInfo) {
			ExchangeInfo()
		}
		.sheet(isPresented: $showSelectedCurrency) {
			SelectCurrency(topCurrency: $leftCurrency, bottomCurrency: $rightCurrency)
		}
    }
}

#Preview {
    ContentView()
}
