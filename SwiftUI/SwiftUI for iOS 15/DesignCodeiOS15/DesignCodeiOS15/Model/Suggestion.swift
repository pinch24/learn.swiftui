//
//  Suggestion.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/05/02.
//

import SwiftUI

struct Suggestion: Identifiable {
	
	let id = UUID()
	var text: String
}

var suggestions = [
	Suggestion(text: "SwiftUI"),
	Suggestion(text: "React"),
	Suggestion(text: "Design")
]
