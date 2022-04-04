//
//  ContentView.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/04/04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		NavigationView {
			ZStack(alignment: .top) {
				Text("Hello, world!")
					.padding()
			}
			.frame(maxHeight: .infinity, alignment: .top)
			.background(AccountBackground())
			.navigationBarHidden(true)
		}
		.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
