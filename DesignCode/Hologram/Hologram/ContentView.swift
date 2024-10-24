//
//  ContentView.swift
//  Hologram
//
//  Created by MK on 10/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HologramView()
			.frame(width: 200, height: 200)
			.background(Color.white)
			.padding()
    }
}

#Preview {
    ContentView()
}
