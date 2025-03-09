//
//  NumberFactClient.swift
//  TCAStart
//
//  Created by Mk on 3/9/25.
//

import ComposableArchitecture
import Foundation

struct NumberFactClient : Sendable {
	var fetch: @Sendable (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
	static let liveValue = Self(
		fetch: { number in
			let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)")!)
			return String(data: data, encoding: .utf8)!
		}
	)
}

extension DependencyValues {
	var numberFact: NumberFactClient {
		get { self[NumberFactClient.self] }
		set { self[NumberFactClient.self] = newValue }
	}
}
