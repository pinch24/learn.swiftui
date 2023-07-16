//
//  ContentView.swift
//  ViewModifierTutorial
//
//  Created by mk on 2023/07/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		VStack(spacing: 40) {
			Text("Hello, world!")
				.modifier(MyRoundedText())
				
			Text("Good bye!")
				.myRoundedTextStyle()
			
			Image(systemName: "pencil")
				.myRoundedTextStyle()
			
			Rectangle()
				.frame(width: 100, height: 100)
				.myRoundedTextStyle()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MyRoundedText: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.largeTitle)
			.padding()
			.background(.orange)
			.cornerRadius(20)
			.padding()
			.overlay(
				RoundedRectangle(cornerRadius: 25)
					.stroke(lineWidth: 10)
				.foregroundColor(.brown))
	}
}

extension View {
	func myRoundedTextStyle() -> some View {
		modifier(MyRoundedText())
	}
}
