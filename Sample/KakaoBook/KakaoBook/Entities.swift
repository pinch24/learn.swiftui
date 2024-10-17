//
//  Types.swift
//  KakaoBook
//
//  Created by MK on 10/16/24.
//

import Foundation

struct BookData: Codable {
	let documents: [Book]
	let meta: Meta
}

struct Book: Codable, Hashable {
	let title: String
	let contents: String
	let url: String
	let isbn: String
	let datetime: String
	let authors: [String]
	let publisher: String
	let price: Int
	let sale_price: Int
	let thumbnail: String
	let status: String
}

struct Meta: Codable {
	let total_count: Int
	let pageable_count: Int
	let is_end: Bool
}
