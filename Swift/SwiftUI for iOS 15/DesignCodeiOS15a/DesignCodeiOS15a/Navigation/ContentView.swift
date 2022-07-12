//
//  ContentView.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/05/31.
//

import SwiftUI

struct ContentView: View {
	
	@AppStorage("selectedTab") var selectedTab: Tab = .home
	
    var body: some View {
		ZStack(alignment: .bottom) {
			Group {
				switch selectedTab {
					case .home:
						HomeView()
					case .explore:
						AccountView()
					case .notifications:
						AccountView()
					case .library:
						AccountView()
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			TabBar()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .preferredColorScheme(.dark)
			//.previewDevice("iPhone 13 mini")
			//.previewInterfaceOrientation(.landscapeLeft)
			//.previewLayout(.fixed(width: 400, height: 400))
			//.environment(\.sizeCategory, .extraExtraExtraLarge)
    }
}
