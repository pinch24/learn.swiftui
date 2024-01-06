//
//  CounterFeatureTests.swift
//  TCATouchTests
//
//  Created by MK on 1/6/24.
//

import XCTest
import ComposableArchitecture
@testable import TCATouch

@MainActor
final class CounterFeatureTests: XCTestCase {
    func tectCounterFeature() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number." }
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
        
        await store.send(.numberFactButtonTapped)
        await store.receive(\.numberFactResponse) {
            $0.numberFactAlert = "0 is a good number."
        }
        
        await store.send(.factAlertDismissed) {
            $0.numberFactAlert = nil
        }
    }
}
