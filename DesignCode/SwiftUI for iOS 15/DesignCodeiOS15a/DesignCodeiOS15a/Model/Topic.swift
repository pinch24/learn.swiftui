//
//  Topic.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/08/16.
//

import SwiftUI

struct Topic: Identifiable {
	let id = UUID()
	var title: String
	var icon: String
}

var topics = [
	Topic(title: "iOS Development", icon: "iphone"),
	Topic(title: "UI Design", icon: "eyedropper"),
	Topic(title: "Web development", icon: "laptopcomputer")
]