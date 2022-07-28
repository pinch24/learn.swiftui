//
//  AccountView.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/06.
//

import SwiftUI

struct AccountView: View {
	
	@Environment(\.presentationMode) var presentationMode
	
	@State var isDeleted = false
	@State var isPinned = false
	
	var body: some View {
		NavigationView {
			List {
				profile
				menu
				links
			}
			.listStyle(.insetGrouped)
			.navigationTitle("Account")
			.navigationBarItems(trailing: Button { presentationMode.wrappedValue.dismiss() } label: { Text("Done").bold() })
		}
	}
	
	var profile: some View {
		VStack(spacing: 8) {
			Image(systemName: "person.crop.circle.fill.badge.checkmark")
				.font(.system(size: 32))
				.symbolRenderingMode(.palette)
				.foregroundStyle(.blue, .blue.opacity(0.3))
				.padding()
				.background(Circle().fill(.ultraThinMaterial))
				.background(
					HexagonView()
						.offset(x: -50, y: -100)
				)
				.background(
					BlobView()
						.offset(x: 200, y: 0)
						.scaleEffect(0.6)
				)
			Text("Meng To")
				.font(.title.weight(.semibold))
			HStack {
				Image(systemName: "location")
					.imageScale(.large)
				Text("Canada")
					.foregroundColor(.secondary)
			}
		}
		.frame(maxWidth: .infinity)
		.padding()
	}
	
	var menu: some View {
		Section {
			NavigationLink(destination: HomeView()) {
				Label("Settings", systemImage: "gear")
			}
			NavigationLink { Text("Billing") } label: {
				Label("Billing", systemImage: "creditcard")
			}
			NavigationLink { HomeView() } label: {
				Label("Help", systemImage: "questionmark")
					.imageScale(.small)
			}
		}
		.accentColor(.primary)
		.listRowSeparatorTint(.blue)
		.listRowSeparator(.hidden)
	}
	
	var links: some View {
		Section {
			if isDeleted == false {
				Link(destination: URL(string: "https://apple.com")!) {
					HStack {
						Label("Website", systemImage: "house")
						Spacer()
						Image(systemName: "link")
							.foregroundColor(.secondary)
					}
				}
				.swipeActions(edge: .leading, allowsFullSwipe: true) {
					Button(action: { isDeleted = true }) {
						Label("Delete", systemImage: "trash")
					}
					.tint(.red)
					
					pinButton
				}
			}
			
			Link(destination: URL(string: "https://youtube.com")!) {
				HStack {
					Label("Youtube", systemImage: "tv")
					Spacer()
					Image(systemName: "link")
						.foregroundColor(.secondary)
				}
			}
			.swipeActions {
				pinButton
			}
		}
		.accentColor(.primary)
		.listRowSeparator(.hidden)
	}
	
	var pinButton: some View {
		Button { isPinned.toggle() } label: {
			if isPinned {
				Label("Unpin", systemImage: "pin.slash")
			}
			else {
				Label("Pin", systemImage: "pin")
			}
			
		}
		.tint(isPinned ? .gray : .yellow)
	}
}

struct AccountView_Previews: PreviewProvider {
	static var previews: some View {
		AccountView()
			.preferredColorScheme(.dark)
		
		AccountView()
	}
}
