//
//  ContentView.swift
//  AutoScrollingTabs
//
//  Created by mk on 2023/02/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		NavigationStack {
			Home()
		}
		.preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
