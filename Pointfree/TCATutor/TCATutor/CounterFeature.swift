//
//  CounterFeature.swift
//  TCATutor
//
//  Created by mk on 12/20/23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CounterFeature {
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
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .decrementButtonTapped:
				state.count -= 1
				return .none
			case .incrementButtonTapped:
				state.count += 1
				return .none
				
			case .factButtonTapped:
				state.fact = nil
				state.isLoading = true
				
				return .run { [count = state.count] send in
					let urlString = "http://numbersapi.com/\(count)"
					let url = URL(string: urlString)!
					let (data, _) = try await URLSession.shared.data(from: url)
					let fact = String(decoding: data, as: UTF8.self)
					await send(.factResponse(fact))
				}
			case let .factResponse(fact):
				state.fact = fact
				state.isLoading = false
				return .none
				
			case .toggleTimerButtonTapped:
				state.isTimerRunning.toggle()
				if state.isTimerRunning {
					return .run { send in
						while true {
							try await Task.sleep(for: .seconds(1))
							await send(.timerTick)
						}
					}
					.cancellable(id: CancelID.timer)
				}
				else {
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
