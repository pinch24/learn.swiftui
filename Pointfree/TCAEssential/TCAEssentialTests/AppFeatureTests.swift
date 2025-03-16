//
//  AppFeatureTests.swift
//  TCAEssentialTests
//
//  Created by MK on 3/16/25.
//

import ComposableArchitecture
import Testing

@testable import TCAEssential

struct AppFeatureTests {
    @Test
	func incrementInFirstTab() async {
		let store = TestStore(initialState: AppFeature.State(), reducer: { AppFeature() })
		
		await store.send(\.tab1.incrementButtonTapped) {
			$0.tab1.count = 1
		}
    }

}
