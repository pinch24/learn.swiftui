//
//  ContentView.swift
//  RGBullsEye
//
//  Created by mk on 12/10/23.
//

import SwiftUI

struct ContentView: View {
	@State var game = Game()
	@State var guess: RGB
	@State var showScore = false
	
	let circleSize: CGFloat = 0.275
	let labelHeight: CGFloat = 0.06
	let labelWidth: CGFloat = 0.53
	let buttonWidth: CGFloat = 0.87
	
    var body: some View {
		GeometryReader { proxy in
			ZStack {
				Color.element
					.ignoresSafeArea()
				
				VStack {
					ColorCircle(rgb: game.target, size: proxy.size.height * circleSize)
					BevelText(text: showScore ? game.target.intString() : "RGB",
							  width: proxy.size.width * labelWidth,
							  height: proxy.size.height * labelHeight)
					
					ColorCircle(rgb: guess, size: proxy.size.height * circleSize)
					BevelText(text: guess.intString(),
							  width: proxy.size.width * labelWidth,
							  height: proxy.size.height * labelHeight)
					
					ColorSlider(value: $guess.red, trackColor: .red)
					ColorSlider(value: $guess.green, trackColor: .green)
					ColorSlider(value: $guess.blue, trackColor: .blue)
					
					if (showScore) {
						HStack {
							Spacer()
							Text("Your Score: ")
							Text(String(game.scoreRound))
								.padding(.trailing, proxy.size.width * labelHeight)
							Button("Retry!") {
								showScore = false
								game.startNewRound()
								// guess = RGB()
							}
							Spacer()
						}
						.padding(.horizontal)
					}
					
					Button("Hit Me!") {
						showScore = true
						game.check(guess: guess)
					}
					.buttonStyle(
						NeuButtonStyle(width: proxy.size.width * buttonWidth, height: proxy.size.height * labelHeight))
				}
				.font(.headline)
			}
		}
    }
}

#Preview {
	ContentView(guess: RGB())
}

struct ColorCircle: View {
	let rgb: RGB
	let size: CGFloat
	
	var body: some View {
		ZStack {
			Circle()
				.fill(.element)
				.northWestShadow()
			Circle()
				.fill(Color(rgbStruct: rgb))
				.padding(20)
		}
		.frame(width: size, height: size)
	}
}


struct ColorSlider: View {
	@Binding var value: Double
	
	var trackColor: Color
	
	var body: some View {
		HStack {
			Text("0")
			Slider(value: $value)
				.accentColor(trackColor)
			Text("255")
		}
		.font(.subheadline)
		.padding(.horizontal)
	}
}
