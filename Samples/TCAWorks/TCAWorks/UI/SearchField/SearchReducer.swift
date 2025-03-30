//
//  SearchReducer.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import ComposableArchitecture

@Reducer
struct SearchReducer {
	@ObservableState
	struct State: Equatable {
		var text: String = ""
		var isFocused: Bool = false
		
		var searchResults: [String] = []
		
		var error: String?
		
		var searchList: [String] = [
			"Apple", "Google", "Microsoft", "Amazon", "Meta"
		]
		
		init() {}
		init(text: String = "", isFocused: Bool = false) {
			self.text = text
			self.isFocused = isFocused
		}
	}
	
	init() {}
	
	enum Action {
		case updateFocus(Bool)
		case textChanged(String)
		case saveSearchList(String)
		case deleteSearchList(String)
		case clearSearchList
	}
	
	@Dependency(\.searchDataClient) var searchClient
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .updateFocus(let isFocused):
				state.isFocused = isFocused
				return .none
			case .textChanged(let text):
				state.text = text
				let results = searchClient.searchItems()
					.filter { $0.localizedCaseInsensitiveContains(text) }
					.sorted()
				state.searchResults = results
				return .none
			case .saveSearchList(let text):
				guard text.isEmpty == false else { return .none }
				if state.searchList.contains(text) == false {
					state.searchList.insert(text, at: 0)
				}
				return .none
			case .deleteSearchList(let text):
				state.searchList.removeAll { $0 == text }
				return .none
			case .clearSearchList:
				state.searchList = []
				return .none
			}
		}
	}
}

// MARK: - Dependency
struct SearchDataClient : Sendable {
	var searchItems: @Sendable () -> [String]
	init(searchItems: @Sendable @escaping () -> [String]) {
		self.searchItems = searchItems
	}
}

extension SearchDataClient : DependencyKey {
	static let liveValue = SearchDataClient {
		[]
	}
}

extension DependencyValues {
	var searchDataClient: SearchDataClient {
		get {
			self[SearchDataClient.self]
		} set {
			self[SearchDataClient.self] = newValue
		}
	}
}
