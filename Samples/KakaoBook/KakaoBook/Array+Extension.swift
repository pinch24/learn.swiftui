//
//  Array+Extension.swift
//  KakaoBook
//
//  Created by MK on 10/16/24.
//

import Foundation

/// @AppStorage가 [String] 타입을 저장할 수 있도록 Array를 Strinig으로 인코딩/디코딩
extension Array: @retroactive RawRepresentable where Element: Codable {
	public init?(rawValue: String) {
		guard let data = rawValue.data(using: .utf8),
			  let result = try? JSONDecoder().decode([Element].self, from: data)
		else {
			return nil
		}
		self = result
	}

	public var rawValue: String {
		guard let data = try? JSONEncoder().encode(self),
			  let result = String(data: data, encoding: .utf8)
		else {
			return "[]"
		}
		return result
	}
}
