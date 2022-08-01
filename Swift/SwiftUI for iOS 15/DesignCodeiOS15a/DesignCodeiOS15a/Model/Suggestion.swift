//
//  Suggesstion.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/08/01.
//

import SwiftUI

struct Suggestion: Identifiable {
	var id = UUID()
	var text: String
}

var suggestions = [
	Suggestion(text: "SwiftUI"),
	Suggestion(text: "React"),
	Suggestion(text: "Design")
]
