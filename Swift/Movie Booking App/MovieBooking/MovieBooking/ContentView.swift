//
//  ContentView.swift
//  MovieBooking
//
//  Created by mk on 2022/10/06.
//

import SwiftUI

struct ContentView: View {
	@State var currentTab: Tab = .home
	
	init() {
		UITabBar.appearance().isHidden = true
	}
	
    var body: some View {
		VStack(spacing: 0) {
			TabView(selection: $currentTab) {
				HomeView()
				Text("Location")
					.tag(Tab.location)
				TicketView()
					.tag(Tab.ticket)
				Text("Category")
					.tag(Tab.category)
				Text("Profile")
					.tag(Tab.profile)
			}
			
			CustomTabBar(currentTab: $currentTab)
		}
		.ignoresSafeArea(.keyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
