//
//  SearchView.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SearchReducer {
	@ObservableState
	struct State: Equatable, Sendable {
		var text: String = ""
		
		var isFocused: Bool = false
		var isExpanded: Bool = false
		var isNeedFilter: Bool = false
		
		var searchList: [String] = []
		var searchResults: [String] = []
		
		var error: String?
		
		var minY: CGFloat = .zero
		var offset: CGFloat = .zero
		var height: CGFloat {
			if offset <= 0 {
				return max(minY + offset + 64, 0)
			} else {
				if minY <= 0 {
					return 64
				} else {
					return min(offset, 64)
				}
			}
		}
		
		init(text: String = "", isFocused: Bool = false, isExpanded: Bool = false, isNeedFilter: Bool = false) {
			self.text = text
			self.isFocused = isFocused
			self.isExpanded = isExpanded
			self.isNeedFilter = isNeedFilter
		}
	}
	
	enum Action: Equatable {
		case dismiss
		
		case updateFocus(Bool)
		case updateExpanded(Bool)
		case textChanged(String)
		
		case saveSearchList(String)
		case deleteSearchList(String)
		case clearSearchList
		
		case updateOffset(CGFloat)
		case updateMinY(CGFloat)
	}
	
	@Dependency(\.searchDataClient) var searchClient
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .dismiss:
				return .none
				
			case .updateFocus(let isFocused):
				state.isFocused = isFocused
				return .none
				
			case .updateExpanded(let isExpanded):
				state.isExpanded = isExpanded
				return .none
				
			case .textChanged(let text):
				state.text = text
				let results = searchClient.searchItems()
					.filter { $0.localizedCaseInsensitiveContains(text) }
					.sorted()
				state.searchResults = results
				return .none
				
			case .saveSearchList(let text):
				guard !text.isEmpty else { return .none }
				
				if !state.searchList.contains(text) {
					state.searchList.insert(text, at: 0)
				}
				return .none
				
			case .deleteSearchList(let text):
				state.searchList.removeAll { $0 == text }
				return .none
				
			case .clearSearchList:
				state.searchList = []
				return .none
				
			case .updateOffset(let value):
				state.offset = value
				return .none

			case .updateMinY(let value):
				state.minY = value
				return .none
			}
		}
	}
}

// MARK: - Dependency
struct SearchDataClient: Sendable {
	var searchItems: @Sendable () -> [String]
	init(searchItems: @Sendable @escaping () -> [String]) {
		self.searchItems = searchItems
	}
}

extension SearchDataClient: DependencyKey {
	static let liveValue = SearchDataClient {
		[]
	}
}

extension DependencyValues {
	var searchDataClient: SearchDataClient {
		get { self[SearchDataClient.self] }
		set { self[SearchDataClient.self] = newValue }
	}
}

// MARK: - View
struct SearchView: View {
	let store: StoreOf<SearchReducer>
	let viewStore: ViewStoreOf<SearchReducer>
	
	init(store: StoreOf<SearchReducer>) {
		self.store = store
		self.viewStore = .init(store, observe: \.self)
	}
	
	var body: some View {
		VStack {
			SearchField(
				searchText: Binding(
					get: { viewStore.text },
					set: { viewStore.send(.textChanged($0)) }
				),
				isFilterEnabled: viewStore.isNeedFilter,
				onSubmit: { viewStore.send(.saveSearchList($0)) },
				onBack: { viewStore.send(.dismiss) }
			)
			SearchLog(
				searchList: viewStore.searchList,
				onSelect: { viewStore.send(.textChanged($0)) },
				onDelete: { viewStore.send(.deleteSearchList($0)) },
				onClear: { viewStore.send(.clearSearchList) }
			)
			SearchResult(
				list: viewStore.searchResults,
				onSelect: { viewStore.send(.saveSearchList($0)) }
			)
		}
		.padding()
	}
}

#Preview {
	SearchPreview()
}

struct SearchPreview: View {
	let store1 = Store(
		initialState: SearchReducer.State(isNeedFilter: true),
		reducer: { SearchReducer() },
		withDependencies: {
			$0.searchDataClient = .init { sampleData }
		}
	)
	
	let store2 = Store(
		initialState: SearchReducer.State(),
		reducer: { SearchReducer() },
		withDependencies: {
			$0.searchDataClient = .init { sampleData }
		}
	)
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				SearchView(store: store1)
				Spacer()
			}
			.navigationBarBackButtonHidden()
			
			NavigationLink {
				VStack(alignment: .leading) {
					SearchView(store: store2)
					Spacer()
				}
				.navigationBarBackButtonHidden()
			} label: {
				Text("검색 테스트(푸시)")
					.tint(.primary)
			}
		}
	}
}

let sampleData = [
	"Apple", "Microsoft", "Google", "Amazon", "Facebook (Meta)", "IBM", "Oracle", "Intel",
	"Samsung", "LG", "Sony", "Dell", "Cisco", "HP", "Salesforce", "Adobe", "VMware", "Twitter",
	"Netflix", "PayPal", "Uber", "Airbnb", "Dropbox", "Slack", "Spotify", "Tencent", "Alibaba",
	"Huawei", "Xiaomi", "Lenovo", "ASUS", "Acer", "Broadcom", "Qualcomm", "SAP", "Atlassian",
	"Shopify", "GitHub", "GitLab", "Pinterest", "Snap Inc.", "Zoom", "Square (Block)", "Stripe",
	"Reddit", "SpaceX", "Tesla", "Palantir", "Twilio", "Epic Games", "Activision Blizzard",
	"Electronic Arts", "Unity Technologies", "Rovio Entertainment", "Nokia", "Ericsson", "Fujitsu",
	"Panasonic", "Sharp", "Hitachi", "Toshiba", "NEC", "Canon", "Nikon", "GoPro", "Garmin",
	"Western Digital", "Seagate", "Kingston", "Sandisk", "Cloudflare", "Akamai Technologies",
	"Okta", "Palo Alto Networks", "Fortinet", "Check Point", "CrowdStrike", "NortonLifeLock",
	"Datadog", "MongoDB", "Splunk", "Snowflake", "OpenAI", "DeepMind", "Boston Dynamics", "Waymo",
	"Cruise", "Naver", "LINE Corporation", "Kakao", "Coupang", "Rakuten", "Baidu", "ByteDance",
	"Didi Chuxing", "Grab", "Gojek", "Zillow", "Booking.com", "Expedia"
]
