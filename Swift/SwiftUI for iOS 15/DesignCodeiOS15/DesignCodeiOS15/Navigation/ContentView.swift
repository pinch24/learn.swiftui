//
//  ContentView.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/04/01.
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
					case .notification:
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
		Group {
			ContentView()
			ContentView()
				.preferredColorScheme(.dark)
				.previewDevice("iPhone 13 mini")
				.previewInterfaceOrientation(.portrait)
		}
    }
}
