//
//  ContentView.swift
//  Hologram
//
//  Created by MK on 10/24/24.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		TabView {
			CardView()
				.tabItem {
					Image(systemName: "creditcard")
					Text("Card")
				}
				.padding(.bottom, 44)
			HologramView()
				.tabItem {
					Image(systemName: "square.grid.3x3")
					Text("Hologram")
				}
				.padding(.bottom, 44)
			SunflowerView()
				.tabItem {
					Image(systemName: "sun.min")
					Text("Sunflower")
				}
				.padding(.bottom, 44)
		}
		.tint(.indigo)
		//.edgesIgnoringSafeArea(.all)
	}
}

#Preview {
	ContentView()
		.preferredColorScheme(.dark)
}
