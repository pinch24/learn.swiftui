//
//  ContentView.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/04/01.
//

import SwiftUI

struct ContentView: View {
	
    var body: some View {
		
		VStack(alignment: .leading, spacing: 8.0) {
			
			Spacer()
			
			Image("Logo 2")
				.resizable(resizingMode: .stretch)
				.aspectRatio(contentMode: .fit)
				.frame(width: 26.0, height: 26.0)
				.cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
				
			Text("SwiftUI for iOS 15")
				.font(.largeTitle)
				.fontWeight(.bold)
			
			Text(/*@START_MENU_TOKEN@*/"20 sections - 3 hours"/*@END_MENU_TOKEN@*/.uppercased())
				.font(.footnote)
				.fontWeight(.semibold)
				.foregroundColor(.secondary)
			
			Text("Build an iOS app for iOS 15 with custom layouts, animations and ...")
				.font(.footnote)
				.multilineTextAlignment(.leading)
				.lineLimit(2)
				.frame(maxWidth: .infinity, alignment: .leading)
				.foregroundColor(.secondary)
		}
		.padding(/*@START_MENU_TOKEN@*/.all, 20.0/*@END_MENU_TOKEN@*/)
		.padding(.vertical, 20)
		.frame(height: 350.0)
		.background(Color("Background"))
		.cornerRadius(/*@START_MENU_TOKEN@*/30.0/*@END_MENU_TOKEN@*/)
		.shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 10)
		.padding(.horizontal, 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			ContentView()
			ContentView()
				.preferredColorScheme(.dark)
				.environment(\.sizeCategory, .accessibilityLarge)
				.previewDevice("iPhone 13 mini")
				.previewInterfaceOrientation(.portrait)
		}
    }
}
