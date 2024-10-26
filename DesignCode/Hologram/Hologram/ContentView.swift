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
			Spacer(minLength: 88)
			
			HologramView()
				.frame(width: 200, height: 200)
			
			SunflowerView()
		}
		.edgesIgnoringSafeArea(.all)
	}
}

#Preview {
	ContentView()
		.preferredColorScheme(.dark)
}
