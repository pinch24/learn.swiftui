//
//  SearchView.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SearchView
public struct SearchView: View {
	let store: StoreOf<SearchFieldReducer>
	
	public init(store: StoreOf<SearchFieldReducer>) {
		self.store = store
	}
	
	public var body: some View {
		WithViewStore(
			store.scope(
				state: \.viewState,
				action: \.viewAction),
			observe: { $0 },
			content: { viewStore in
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
		)
	}
}

#Preview {
	SearchPreview()
}

struct SearchPreview: View {
	let store1 = Store(
		initialState: SearchFieldReducer.State(isNeedFilter: true),
		reducer: { SearchFieldReducer() },
		withDependencies: {
			$0.searchDataClient = .init { sampleData }
		}
	)
	
	let store2 = Store(
		initialState: SearchFieldReducer.State(),
		reducer: { SearchFieldReducer() },
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
