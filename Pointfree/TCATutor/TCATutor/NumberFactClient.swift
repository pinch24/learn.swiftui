//
//  NumberFactClient.swift
//  TCATutor
//
//  Created by mk on 12/21/23.
//

import Foundation
import ComposableArchitecture

struct NumberFactClient {
	var fetch: (Int) async throws -> String
	var todo: (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
	static let liveValue = Self(fetch: { number in
		let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)")!)
		return String(decoding: data, as: UTF8.self)
	}, todo: { number in
		var value = "No activity found with the specified parameters."
		let (data, _) = try await URLSession.shared.data(from: URL(string: "https://www.boredapi.com/api/activity?participants=\(number)")!)
		let string = String(decoding: data, as: UTF8.self)
		if let frontRange = string.range(of: "{\"activity\":\""),
		   let backRange = string.range(of: "\",\"type\":") {
			value = String(string[frontRange.upperBound..<backRange.lowerBound])
		}
		return value
	})
}

extension DependencyValues {
	var numberFact: NumberFactClient {
		get { self[NumberFactClient.self] }
		set { self[NumberFactClient.self] = newValue }
	}
}
