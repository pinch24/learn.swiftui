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
            QuoteView(show: "Breaking Bad View")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Breaking Bad", systemImage: "tortoise")
                }
            
            QuoteView(show: "Better Call Saul View")
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label("Better Call Saul", systemImage: "briefcase")
                }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
