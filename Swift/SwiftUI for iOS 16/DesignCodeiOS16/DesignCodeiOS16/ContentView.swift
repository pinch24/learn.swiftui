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
			Image(systemName: "timelapse")
				.imageScale(.large)
				.foregroundColor(.accentColor)
				.font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
			Text("Switching Apps")
				.font(.largeTitle)
				.fontWeight(.bold)
			Text("Tap and hold any part of the screen for 1 second to show the menu for switching between apps.")
				.multilineTextAlignment(.center)
			Button("Got it") {
				
			}
			.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
			.frame(width: 300.0)
			.border(/*@START_MENU_TOKEN@*/Color("AccentColor")/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
			
		}
		.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
