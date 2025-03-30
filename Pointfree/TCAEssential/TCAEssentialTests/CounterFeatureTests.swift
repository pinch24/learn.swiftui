//
//  CounterFeatureTests.swift
//  TCAEssentialTests
//
//  Created by MK on 3/16/25.
//

import ComposableArchitecture
import Testing

@testable import TCAEssential

@MainActor
struct CounterFeatureTests {
    @Test
	func basics() async {
		let store = TestStore(initialState: CounterFeature.State(), reducer: { CounterFeature() })
		
		await store.send(.incrementButtonTapped) {
			$0.count = 1
		}
		await store.send(.decrementButtonTapped) {
			$0.count = 0
		}
    }
	
	@Test
	func timer() async {
		let clock = TestClock()
		let store = TestStore(
			initialState: CounterFeature.State(),
			reducer: { CounterFeature() },
			withDependencies: { $0.continuousClock = clock }
		)
		
		await store.send(.toggleTimerButtonTapped) {
			$0.isTimerRunning = true
		}
		await clock.advance(by: .seconds(1))
		await store.receive(\.timerTick) {
			$0.count = 1
		}
		await store.send(.toggleTimerButtonTapped) {
			$0.isTimerRunning = false
		}
	}
	
	@Test
	func numberFact() async {
		let store = TestStore(
			initialState: CounterFeature.State(),
			reducer: { CounterFeature() },
			withDependencies: {
				$0.numberFact.fetch = { "\($0) is a good number." }
			}
		)
		
		await store.send(.factButtonTapped) {
			$0.isLoading = true
		}
		await store.receive(\.factResponse, timeout: .seconds(1)) {
			$0.isLoading = false
			$0.fact = "0 is a good number."
			//$0.fact = "0 is the atomic number of the theoretical element tetraneutron."
			//$0.fact = "0 is the coldest possible temperature old the Kelvin scale."
		}
	}
}
