//
//  CustomTabBar.swift
//  MovieBooking
//
//  Created by mk on 2022/10/14.
//

import SwiftUI

struct CustomTabBar: View {
	@Binding var currentTab: Tab
	
    var body: some View {
		HStack(spacing: 0) {
			ForEach(Tab.allCases, id: \.rawValue) { tab in
				Image(tab.rawValue)
					.renderingMode(.template)
					.frame(maxWidth: .infinity)
					.foregroundColor(.white)
			}
		}
		.frame(maxWidth: .infinity)
		.background(.red)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
		//CustomTabBar(currentTab: .constant(.home))
		ContentView()
    }
}
