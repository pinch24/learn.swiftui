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
		}
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
