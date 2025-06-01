//
//  ContentView.swift
//  Calendar
//
//  Created by MK on 5/15/25.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = CalendarViewModel()
	
	var body: some View {
		TabView {
			NavigationView {
				CalendarView()
					.environmentObject(viewModel)
					.navigationTitle("Calendar")
			}
			.tabItem {
				Label("Calendar", systemImage: "calendar")
			}
			
			NavigationView {
				EventListView()
					.environmentObject(viewModel)
					.navigationTitle("Events")
			}
			.tabItem {
				Label("Events", systemImage: "list.bullet")
			}
		}
		.sheet(isPresented: $viewModel.showNewEventSheet) {
			NewEventView()
				.environmentObject(viewModel)
		}
		.accentColor(.red)
	}
}

#Preview {
    ContentView()
}
