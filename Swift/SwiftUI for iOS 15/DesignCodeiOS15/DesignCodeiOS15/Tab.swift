//
//  Tab.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/04/17.
//

import SwiftUI

struct TabItem: Identifiable {
	
	var id = UUID()
	var text: String
	var icon: String
}

var tabItems = [
	TabItem(text: "Learn Now", icon: "house"),
	TabItem(text: "Explorer", icon: "magnifyingglass"),
	TabItem(text: "Notifications", icon: "bell"),
	TabItem(text: "Library", icon: "rectangle.stack")
]
