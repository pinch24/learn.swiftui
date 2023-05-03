//
//  Home.swift
//  AutoScrollingTabs
//
//  Created by mk on 2023/02/17.
//

import SwiftUI

struct Home: View {
	@State private var activeTab: ProductType = .iphone
	@Namespace private var animation
	
    var body: some View {
		ScrollViewReader { proxy in
			ScrollView(.vertical, showsIndicators: false) {
				LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
					Section {
						
					} header: {
						ScrollableTabs()
					}
				}
			}
		}
		.navigationTitle("AppleStore")
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarBackground(Color("Purple"), for: .navigationBar)
		.toolbarColorScheme(.dark, for: .navigationBar)
    }
	
	@ViewBuilder
	func ScrollableTabs() -> some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
				ForEach(ProductType.allCases, id: \.rawValue) { type in
					Text(type.rawValue)
						.fontWeight(.semibold)
						.foregroundColor(.white)
						.background(alignment: .bottom, content: {
							if activeTab == type {
								Capsule()
									.fill(.white)
									.frame(height: 5)
									.padding(.horizontal, -5)
									.offset(y: 15)
									.matchedGeometryEffect(id: "ACTIVETAB", in: animation)
							}
						})
						.padding(.horizontal, 15)
						.contentShape(Rectangle())
						.onTapGesture {
							withAnimation(.easeInOut(duration: 0.3)) {
								activeTab = type
							}
						}
				}
			}
			.padding(.vertical, 15)
		}
		.background {
			Rectangle()
				.fill(Color("Purple"))
				.shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
		}
	}
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        //Home()
		ContentView()
    }
}
