//
//  FAQ.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/12/26.
//

import Foundation

struct FAQ: Identifiable, Decodable {
	var id: Int
	var question: String
	var answer: String
}
