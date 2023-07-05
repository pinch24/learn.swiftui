//
//  ContentView.swift
//  CircularSlider
//
//  Created by mk on 2023/07/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		NavigationStack {
			Home()
				.navigationTitle("Trip Planner")
		}
    }
}

#Preview {
    ContentView()
}
