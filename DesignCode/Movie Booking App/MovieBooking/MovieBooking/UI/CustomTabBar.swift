//
//  CustomTabBar.swift
//  MovieBooking
//
//  Created by mk on 2022/10/14.
//

import SwiftUI

struct CustomTabBar: View {
	@Binding var currentTab: Tab
	
	var backgroundColors = [Color("purple"), Color("lightBlue"), Color("pink")]
	var gradientCircle = [Color("cyan"), Color("cyan").opacity(0.1), Color("cyan")]
	
	var body: some View {
		GeometryReader { geometry in
			let width = geometry.size.width
			
			HStack(spacing: 0) {
				ForEach(Tab.allCases, id: \.rawValue) { tab in
					Button {
						withAnimation {
							currentTab = tab
						}
					} label: {
						Image(tab.rawValue)
							.renderingMode(.template)
							.frame(maxWidth: .infinity)
							.foregroundColor(.white)
							.offset(y: currentTab == tab ? -17 : 0)
					}
				}
			}
			.frame(maxWidth: .infinity)
			.background(alignment: .leading) {
				Circle()
					.fill(.ultraThinMaterial)
					.frame(width: 80, height: 80)
					.shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
					.offset(x: indicatorOffset(width: width), y: -17)
					.overlay(
						Circle()
							.trim(from: 0, to: 0.5)
							.stroke(LinearGradient(colors: gradientCircle, startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 2))
							.rotationEffect(.degrees(135))
							.frame(width: 78, height: 78)
							.offset(x: indicatorOffset(width: width), y: -17)
					)
			}
		}
		.frame(height: 24)
		.padding(.top, 30)
		.background(.ultraThinMaterial)
		.background(LinearGradient(colors: backgroundColors, startPoint: .topLeading, endPoint: .bottomTrailing))
	}
	
	func indicatorOffset(width: CGFloat) -> CGFloat {
		let index = CGFloat(getIndex())
		if index == 0 { return 0 }
		let buttonWidth = width / CGFloat(Tab.allCases.count)
		return index * buttonWidth
	}
	
	func getIndex() -> Int {
		switch currentTab {
			case .home:
				return 0
			case .location:
				return 1
			case .ticket:
				return 2
			case .category:
				return 3
			case .profile:
				return 4
		}
	}
}

struct CustomTabBar_Previews: PreviewProvider {
	static var previews: some View {
		//CustomTabBar(currentTab: .constant(.home))
		ContentView()
	}
}
