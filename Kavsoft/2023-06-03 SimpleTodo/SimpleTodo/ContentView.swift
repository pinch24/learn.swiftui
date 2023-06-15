//
//  ContentView.swift
//  SimpleTodo
//
//  Created by mk on 2023/06/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		NavigationStack {
			Home()
				.navigationTitle("To-Do")
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
