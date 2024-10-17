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
            QuoteView(show: "Breaking Bad")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Breaking Bad", systemImage: "tortoise")
                }
            
            QuoteView(show: "Better Call Saul")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Better Call Saul", systemImage: "briefcase")
                }
			
			QuoteView(show: "El Camino")
				.toolbarBackground(.visible, for: .tabBar)
				.tabItem {
					Label("El Camino", systemImage: "car")
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
 -  On CharacterView, auto-scroll to bottom after status is shown
 -  Fetch episode data
 -  Create static constants for show names
 */
