//
//  ContentFeatureTests.swift
//  TCATutorTests
//
//  Created by mk on 12/21/23.
//

import XCTest
import ComposableArchitecture
@testable import TCATutor

@MainActor
final class ContentFeatureTests: XCTestCase {
	func testIncrementInFirstTab() async {
		let store = TestStore(initialState: ContentFeature.State()) {
			ContentFeature()
		}
		
		await store.send(.tab1(.incrementButtonTapped)) {
			$0.tab1.count = 1
		}
	}
}
