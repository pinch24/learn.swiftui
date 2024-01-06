//
//  CounterView.swift
//  TCATouch
//
//  Created by MK on 1/6/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - View
struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Button("-") { viewStore.send(.decrementButtonTapped) }
                    Text("\(viewStore.count)")
                    Button("+") { viewStore.send(.incrementButtonTapped) }
                }
                
                Button("Number fact") { viewStore.send(.numberFactButtonTapped) }
            }
            .alert(
                item: viewStore.binding(
                    get: { $0.numberFactAlert.map(FactAlert.init(title:)) },
                    send: .factAlertDismissed),
                content: { Alert(title: Text($0.title)) })
        }
    }
    
    struct FactAlert: Identifiable {
        var title: String
        var id: String { self.title }
    }
}

#Preview {
    CounterView(store: Store(initialState: CounterFeature.State(), reducer: {
        CounterFeature()
    }))
}

// MARK: - Feature
@Reducer
struct CounterFeature {
    struct State: Equatable {
        var count = 0
        var numberFactAlert: String?
    }
    
    enum Action {
        case factAlertDismissed
        case decrementButtonTapped
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(String)
    }
    
    @Dependency(\.numberFact) var numberFact
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .factAlertDismissed:
                state.numberFactAlert = nil
                return .none
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            case .incrementButtonTapped:
                state.count += 1
                return .none
            case .numberFactButtonTapped:
                return .run { [count = state.count] send in
                    let fact = try await self.numberFact.fetch(count)
                    await send(.numberFactResponse(fact))
                }
            case let .numberFactResponse(fact):
                state.numberFactAlert = fact
                return .none
            }
        }
    }
}

// MARK: - Dependency
struct NumberFactClient {
    var fetch: (Int) async throws -> String
}

private enum NumberFactClientKey: DependencyKey {
    static let liveValue = NumberFactClient(fetch: { number in
        let (data, _) = try await URLSession.shared.data(from: .init(string: "http://numbersapi.com/\(number)/trivia")!)
        return String(decoding: data, as: UTF8.self)
    })
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClientKey.self] }
        set { self[NumberFactClientKey.self] = newValue }
    }
}
