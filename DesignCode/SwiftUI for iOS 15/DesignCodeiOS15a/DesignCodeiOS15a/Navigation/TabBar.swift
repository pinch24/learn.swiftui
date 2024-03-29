//
//  TabBar.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/12.
//

import SwiftUI

struct TabBar: View {
	@AppStorage("selectedTab") var selectedTab: Tab = .home
	@State var selectedTabColor: Color = .teal
	@State var tabItemWidth: CGFloat = 0
	
    var body: some View {
		GeometryReader { proxy in
			let hasHomeIndicator = proxy.safeAreaInsets.bottom - 88 > 20
			
			HStack {
				buttons
			}
			.padding(.horizontal, 8)
			.padding(.top, 14)
			.frame(height: hasHomeIndicator ? 88 : 62, alignment: .top)
			.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: hasHomeIndicator ? 34 : 0, style: .continuous))
			.background(
				background
			)
			.overlay(
				overlay
			)
			.strokeStyle(cornerRadius: hasHomeIndicator ? 34 : 0)
			.frame(maxHeight: .infinity, alignment: .bottom)
			.ignoresSafeArea()
		}
    }
	
	var buttons: some View {
		ForEach(tabItems) { item in
			Button {
				withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
					selectedTab = item.tab
					selectedTabColor = item.color
				}
			} label: {
				VStack(spacing: 0) {
					Image(systemName: item.icon)
						.symbolVariant(.fill)
						.font(.body.bold())
						.frame(width: 44, height: 29)
					Text(item.text)
						.font(.caption2)
						.lineLimit(1)
				}
				.frame(maxWidth: .infinity)
			}
			.foregroundColor(selectedTab == item.tab ? .primary : .secondary)
			.blendMode(selectedTab == item.tab ? .overlay : .normal)
			.overlay {
				GeometryReader { proxy in
					//Text("\(proxy.size.width)")
					Color.clear.preference(key: TabPreferenceKey.self, value: proxy.size.width)
				}
			}
			.onPreferenceChange(TabPreferenceKey.self) { value in
				tabItemWidth = value
			}
		}
	}
	
	var background: some View {
		HStack {
			if selectedTab == .library { Spacer() }
			if selectedTab == .explore { Spacer() }
			if selectedTab == .notifications { Spacer(); Spacer() }
			Circle().fill(selectedTabColor).frame(width: tabItemWidth)
			if selectedTab == .home { Spacer() }
			if selectedTab == .explore { Spacer(); Spacer() }
			if selectedTab == .notifications { Spacer() }
		}
		.padding(.horizontal, 8)
	}
	
	var overlay: some View {
		HStack {
			if selectedTab == .library { Spacer() }
			if selectedTab == .explore { Spacer() }
			if selectedTab == .notifications { Spacer(); Spacer() }
			Rectangle()
				.fill(selectedTabColor)
				.frame(width: 28, height: 5)
				.cornerRadius(3)
				.frame(width: tabItemWidth)
				.frame(maxHeight: .infinity, alignment: .top)
			if selectedTab == .home { Spacer() }
			if selectedTab == .explore { Spacer(); Spacer() }
			if selectedTab == .notifications { Spacer() }
		}
		.padding(.horizontal, 8)
	}
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
		TabBar()
		
		TabBar()
			.previewDevice("iPhone 13 mini")
		
		TabBar()
			.previewDevice("iPhone SE (3rd generation)")
    }
}
