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
    func testCounterFeature() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number." }
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.incrementButtonTapped) {
            $0.count = 2
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 1
        }
        
        await store.send(.numberFactButtonTapped)
        await store.receive(\.numberFactResponse) {
            $0.numberFactAlert = "0 is a good number."
        }
        
        await store.send(.factAlertDismissed) {
            $0.numberFactAlert = nil
        }
    }
	
	func testBasics() {
		let feature = CounterFeature()
		var currentState = CounterFeature.State(count: 0)
		
		_ = feature.reduce(into: &currentState, action: .incrementButtonTapped)
		XCTAssertEqual(currentState, CounterFeature.State(count: 1))
		
		_ = feature.reduce(into: &currentState, action: .decrementButtonTapped)
		XCTAssertEqual(currentState, CounterFeature.State(count: 0))
	}
	
	@MainActor
	func testBasicsA() async {
		let store = TestStore(initialState: CounterFeature.State(count: 0)) {
			CounterFeature()
		}
		await store.send(.incrementButtonTapped) {
			$0.count = 1
		}
		await store.send(.incrementButtonTapped) {
			$0.count = 2
		}
		await store.send(.decrementButtonTapped) {
			$0.count = 1
		}
	}
	
	@MainActor
	func testTimerClockA() async {
		let store = TestStore(initialState: CounterFeature.State(count: 0)) {
			CounterFeature()
		}
		await store.send(.startTimerButtonTapped)
		await store.receive(\.timerTick, timeout: .seconds(2)) {
			$0.count = 1
		}
		await store.receive(\.timerTick, timeout: .seconds(2)) {
			$0.count = 2
		}
		await store.receive(\.timerTick, timeout: .seconds(2)) {
			$0.count = 3
		}
		await store.receive(\.timerTick, timeout: .seconds(2)) {
			$0.count = 4
		}
		await store.receive(\.timerTick, timeout: .seconds(2)) {
			$0.count = 5
		}
	}
	
	@MainActor
	func testTimerClockB() async {
		let store = TestStore(initialState: CounterFeature.State(count: 0)) {
			CounterFeature()
		} withDependencies: {
			$0.continuousClock = ImmediateClock()
		}
		await store.send(.startTimerButtonTapped)
		await store.receive(\.timerTick) {
			$0.count = 1
		}
		await store.receive(\.timerTick) {
			$0.count = 2
		}
		await store.receive(\.timerTick) {
			$0.count = 3
		}
		await store.receive(\.timerTick) {
			$0.count = 4
		}
		await store.receive(\.timerTick) {
			$0.count = 5
		}
	}
}
