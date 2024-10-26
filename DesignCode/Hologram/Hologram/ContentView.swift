//
//  ContentView.swift
//  Hologram
//
//  Created by MK on 10/24/24.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			SunflowerView()
			
			HologramView()
				.frame(width: 200, height: 200)
				.padding(.bottom, 44)
		}
		.edgesIgnoringSafeArea(.all)
	}
}

#Preview {
	ContentView()
		.preferredColorScheme(.dark)
}
