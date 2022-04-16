//
//  TabBar.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/04/17.
//

import SwiftUI

struct TabBar: View {
	
	@State var selectedTab: Tab = .home
	
    var body: some View {
        
		ZStack(alignment: .bottom) {
			
			Group {
				switch selectedTab {
					case .home:
						ContentView()
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.offset(y: 300)
					case .explore:
						AccountView()
					case .notification:
						AccountView()
					case .library:
						AccountView()
				}
			}
			
			HStack {
				Spacer()
				ForEach(tabItems) { item in
					Button {
						selectedTab = item.tab
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
					.foregroundStyle(selectedTab == item.tab ? .primary : .secondary)
				}
			}
			.padding(.horizontal, 8)
			.padding(.top, 14)
			.frame(height: 88, alignment: .top)
			.background(.ultraThinMaterial, in:
							RoundedRectangle(cornerRadius: 34, style: .continuous))
			.strokeStyle(cornerRadius: 34)
			.frame(maxHeight: .infinity, alignment: .bottom)
			.ignoresSafeArea()
		}
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
