//
//  ContentView.swift
//  DesignCodeiOS16
//
//  Created by mk on 2023/01/01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		VStack(alignment: .center, spacing: 20.0) {
			Image(systemName: "timelapse", variableValue: 0.2)
				.imageScale(.large)
				.foregroundColor(.accentColor)
				.font(.system(size: 50))
				.fontWeight(.thin)
			Text("Switching Apps")
				.font(.largeTitle)
				.fontWeight(.bold)
			Text("Tap and hold any part of the screen for 1 second to show the menu for switching between apps.")
				.multilineTextAlignment(.center)
			Button {
				// Action
			} label: {
				Text("Got it")
					.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
					.frame(maxWidth: .infinity)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.stroke()
					)
			}
			.accentColor(.primary)
		}
		.padding(30)
		.background(.ultraThinMaterial)
		.cornerRadius(10)
		.overlay(RoundedRectangle(cornerRadius: 10).stroke())
		.padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.background(Image("Wallpaper 2"))
    }
}
