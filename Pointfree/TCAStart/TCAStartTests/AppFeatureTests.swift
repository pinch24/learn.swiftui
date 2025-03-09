//
//  AppFeatureTests.swift
//  TCAStartTests
//
//  Created by Mk on 3/9/25.
//

import ComposableArchitecture
import Testing

@testable import TCAStart

@MainActor
struct AppFeatureTests {
	@Test
	func incrementInFirstTab() async {
		let store = TestStore(initialState: AppFeature.State(), reducer: { AppFeature() })
		
		await store.send(\.tab1.incrementButtonTapped) {
			$0.tab1.count = 1
		}
	}

}
