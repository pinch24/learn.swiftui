//
//  ContentView.swift
//  SimpleTodo
//
//  Created by Mk on 3/6/25.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationStack {
			Home()
				.navigationTitle(Text("To-do"))
		}
    }
}

#Preview {
    ContentView()
}
