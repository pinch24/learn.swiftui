//
//  HomeView.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/12.
//

import SwiftUI

struct HomeView: View {
	
    var body: some View {
		
		ScrollView {
			
			FeaturedItem()
			
			Color.clear.frame(height: 1000)
		}
		.safeAreaInset(edge: .top, content: {
			Color.clear.frame(height: 70)
		})
		.overlay(
			NavigationBar(title: "Featured")
		)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
