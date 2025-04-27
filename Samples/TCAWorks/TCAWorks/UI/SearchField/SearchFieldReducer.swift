//
//  SearchFieldReducer.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import ComposableArchitecture

@Reducer
public struct SearchFieldReducer {
	@ObservableState
	public struct State: Equatable, Sendable {
		public struct ViewState: Equatable, Sendable {
			// 검색 필드
			public var text: String = ""
			public var isFocused: Bool = false
			public var isExpanded: Bool = false
			
			// 필터/취소 버튼
			public var isNeedFilter: Bool = false
			
			// 검색 결과
			public var searchResults: [String] = []
			
			// 에러 체크
			public var error: String?
			
			// 최근 검색어
			public var searchList: [String] = []
		}
		
		public var viewState: ViewState = ViewState()
		
		public init(text: String = "", isFocused: Bool = false, isExpanded: Bool = false, isNeedFilter: Bool = false) {
			self.viewState.text = text
			self.viewState.isFocused = isFocused
			self.viewState.isExpanded = isExpanded
			self.viewState.isNeedFilter = isNeedFilter
		}
	}
	
	public enum Action: Equatable {
		case viewAction(ViewAction)
		
		public enum ViewAction: Equatable {
			// 네비게이션
			case dismiss
			// 검색 필드
			case updateFocus(Bool)
			case updateExpanded(Bool)
			case textChanged(String)
			// 최근 검색어
			case saveSearchList(String)
			case deleteSearchList(String)
			case clearSearchList
		}
	}
	
	@Dependency(\.searchDataClient) var searchClient
	
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case .viewAction(let action):
					switch action {
						// 네비게이션
						case .dismiss:
							return .none
						// 검색 필드
						case .updateFocus(let isFocused):
							state.viewState.isFocused = isFocused
							return .none
							
						case .updateExpanded(let isExpanded):
							state.viewState.isExpanded = isExpanded
							return .none
							
						case .textChanged(let text):
							state.viewState.text = text
							let results = searchClient.searchItems()
								.filter { $0.localizedCaseInsensitiveContains(text) }
								.sorted()
							state.viewState.searchResults = results
							return .none
							
						// 최근 검색어
						case .saveSearchList(let text):
							guard !text.isEmpty else { return .none }
							
							if !state.viewState.searchList.contains(text) {
								state.viewState.searchList.insert(text, at: 0)
							}
							return .none
							
						case .deleteSearchList(let text):
							state.viewState.searchList.removeAll { $0 == text }
							return .none
							
						case .clearSearchList:
							state.viewState.searchList = []
							return .none
					}
			}
		}
	}
}

// MARK: - Dependency
public struct SearchDataClient: Sendable {
	public var searchItems: @Sendable () -> [String]
	public init(searchItems: @Sendable @escaping () -> [String]) {
		self.searchItems = searchItems
	}
}

extension SearchDataClient: DependencyKey {
	public static let liveValue = SearchDataClient {
		[]
	}
}

extension DependencyValues {
	public var searchDataClient: SearchDataClient {
		get { self[SearchDataClient.self] }
		set { self[SearchDataClient.self] = newValue }
	}
}
