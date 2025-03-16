//
//  CounterFeature.swift
//  TCAEssential
//
//  Created by MK on 3/16/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
	@ObservableState
	struct State: Equatable {
		var count = 0
		var fact: String?
		var isLoading = false
		var isTimerRunning = false
	}
	
	enum Action {
		case decrementButtonTapped
		case incrementButtonTapped
		case factButtonTapped
		case factResponse(String)
		case toggleTimerButtonTapped
		case timerTick
	}
	
	enum CancelID { case timer }
	
	@Dependency(\.continuousClock) var clock
	@Dependency(\.numberFact) var numberFact
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .decrementButtonTapped:
				state.count -= 1
				state.fact = nil
				return .none
			case .incrementButtonTapped:
				state.count += 1
				state.fact = nil
				return .none
				
			case .factButtonTapped:
				state.fact = nil
				state.isLoading = true
				state.isTimerRunning = false
				return .merge(
					.run { [count = state.count] send in
						try await send(.factResponse(self.numberFact.fetch(count)))
					},
					.cancel(id: CancelID.timer)
				)
			case .factResponse(let fact):
				state.fact = fact
				state.isLoading = false
				return .none
				
			case .toggleTimerButtonTapped:
				state.isTimerRunning.toggle()
				if state.isTimerRunning {
					return .run { send in
						for await _ in self.clock.timer(interval: .seconds(1)) {
							await send(.timerTick)
						}
					}
					.cancellable(id: CancelID.timer)
				} else {
					return .cancel(id: CancelID.timer)
				}
			case .timerTick:
				state.count += 1
				state.fact = nil
				return .none
			}
		}
	}
}

struct CounterView: View {
	let store: StoreOf<CounterFeature>
	
	var body: some View {
		VStack {
			Text("\(store.count)")
				.font(.largeTitle)
				.padding()
				.background(Color.black.opacity(0.1))
				.cornerRadius(10)
			HStack {
				Button("-") {
					store.send(.decrementButtonTapped)
				}
				.font(.largeTitle)
				.padding()
				.background(Color.black.opacity(0.1))
				.cornerRadius(10)
				
				Button("+") {
					store.send(.incrementButtonTapped)
				}
				.font(.largeTitle)
				.padding()
				.background(Color.black.opacity(0.1))
				.cornerRadius(10)
			}
			Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
				store.send(.toggleTimerButtonTapped)
			}
			.font(.largeTitle)
			.padding()
			.background(Color.black.opacity(0.1))
			.cornerRadius(10)
			
			Button("Fact") {
				store.send(.factButtonTapped)
			}
			.font(.largeTitle)
			.padding()
			.background(Color.black.opacity(0.1))
			.cornerRadius(10)
			
			if store.isLoading {
				ProgressView()
			} else if let fact = store.fact {
				Text(fact)
					.font(.largeTitle)
					.multilineTextAlignment(.center)
					.padding()
			}
		}
	}
}

#Preview {
	let store = Store(initialState: CounterFeature.State(), reducer: { CounterFeature()._printChanges() })
	CounterView(store: store)
		.frame(width:320, height: 480)
}
