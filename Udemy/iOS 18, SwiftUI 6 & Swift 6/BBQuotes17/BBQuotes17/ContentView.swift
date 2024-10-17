//
//  ContentView.swift
//  BBQuotes17
//
//  Created by MK on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            QuoteView(show: Constants.bbName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label(Constants.bbName, systemImage: "tortoise")
                }
            
            QuoteView(show: Constants.bcsName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label(Constants.bcsName, systemImage: "briefcase")
                }
			
			QuoteView(show: Constants.ecName)
				.toolbarBackground(.visible, for: .tabBar)
				.tabItem {
					Label(Constants.ecName, systemImage: "car")
				}
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

/**
 Version 2 Feature List:
 ☑️ Add El Camino Tab
 ☑️  Utilize all character images on CharacterView
 ☑️   On CharacterView, auto-scroll to bottom after status is shown
 -  Fetch episode data
 ☑️  Extend string to get rid of long image and color names
 ☑️  Create static constants for show names
 */
