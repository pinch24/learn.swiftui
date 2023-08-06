//
//  CounterView.swift
//  TCASimpleTutorial
//
//  Created by mk on 2023/07/16.
//

import SwiftUI
import ComposableArchitecture

struct CounterState: Equatable {
	var count = 0
}

enum CounterAction: Equatable {
	case addCount
	case subtractCount
}

struct CounterEnvironment {}

let counterReducer = AnyReducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
	switch action {
		case .addCount:
			state.count += 1
			return EffectTask.none
		case .subtractCount:
			state.count -= 1
			return EffectTask.none
	}
}

struct CounterView: View {
	
	let store: Store<CounterState, CounterAction>
	
    var body: some View {
		WithViewStore(store) { viewStore in
			VStack {
				Text(viewStore.state.count.description)
					.padding()
				
				HStack {
					Button("Add", action: { viewStore.send(.addCount) })
					Button("Subtract", action: { viewStore.send(.subtractCount) })
				}
			}
		}
    }
}

struct CounterView_Previews: PreviewProvider {
	static var previews: some View {
		let counterStore = Store(initialState: CounterState(), reducer: counterReducer, environment: CounterEnvironment())
        CounterView(store: counterStore)
    }
}
