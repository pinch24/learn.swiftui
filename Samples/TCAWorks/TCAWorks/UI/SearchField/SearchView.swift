//
//  SearchView.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SearchView
struct SearchView: View {
	let store: StoreOf<SearchReducer>
	
    var body: some View {
		VStack {
			SearchField(
				searchText: Binding(get: { store.text }, set: { store.send(.textChanged($0)) }),
				onSubmit: { store.send(.saveSearchList($0)) }
			)
			SearchHistoryView(
				searchList: store.searchList,
				onSelect: { text in store.send(.textChanged(text)) },
				onDelete: { store.send(.deleteSearchList($0)) },
				onClear: { store.send(.clearSearchList) }
			)
			SearchResult(
				searchResults: store.searchResults,
				onSelect: { store.send(.saveSearchList($0)) }
			)
		}
		.padding()
    }
}

// MARK: - SearchField
struct SearchField: View {
	@Binding var searchText: String
	@FocusState private var isFocused: Bool
	
	@State private var isFilterEnabled: Bool = false
	@State private var isFilterPresent: Bool = false
	
	let onSubmit: ((String) -> Void)?
	
	var body: some View {
		HStack {
			HStack {
				Image(systemName: "magnifyingglass")
					.foregroundColor(.gray)
				
				TextField("Search", text: $searchText)
					.focused($isFocused)
					.textFieldStyle(PlainTextFieldStyle())
					.onSubmit {
						onSubmit?(searchText)
					}
				
				if searchText.isEmpty == false {
					Button(action: {
						searchText = ""
					}) {
						Image(systemName: "xmark.circle.fill")
							.foregroundStyle(.gray)
					}
				}
			}
			.padding(10)
			.background(.gray)
			.cornerRadius(10)
			
			if isFilterEnabled {
				filterButton
			} else {
				cancelButton
			}
			
		}
	}
	
	var filterButton: some View {
		Button(action: {
			isFilterPresent.toggle()
		}) {
			Image(systemName: "line.3.horizontal.decrease")
				.resizable()
				.frame(width: 12, height: 12)
				.foregroundColor(.gray)
				.padding(14)
				.background(Color.gray.opacity(0.2))
				.cornerRadius(10)
		}
		.background(Color.gray)
		.cornerRadius(10)
		.sheet(isPresented: $isFilterPresent) {
			FilterOptionView()
		}
		.transition(.opacity)
		.animation(.easeInOut, value: isFocused || searchText.isEmpty == false)
	}
	
	var cancelButton: some View {
		Button("취소") {
			// Dismiss
		}
		.foregroundColor(.blue)
		.transition(.move(edge: .trailing).combined(with: .opacity))
		.animation(.easeInOut, value: isFocused || searchText.isEmpty == false)
	}
}

// MARK: - FilterOptionView
struct FilterOptionView: View {
	@State private var selectedOption: Int = 0
	let options = ["Sort", "Type", "State", "Tag", "Assigner"]
	
	var body: some View {
		NavigationView {
			VStack {
				segmentView
				Spacer()
				Text("\(options[selectedOption])")
				Spacer()
			}
		}
		.navigationTitle(Text("Filter"))
		.navigationBarTitleDisplayMode(.inline)
	}
	
	private var segmentView: some View {
		VStack(alignment: .leading) {
			HStack {
				ForEach(0..<options.count, id: \.self) { index in
					VStack(spacing: 4) {
						Text(options[index])
							.foregroundColor(selectedOption == index ? .primary : .gray)
							.fontWeight(selectedOption == index ? .semibold : .regular)
							.onTapGesture {
								withAnimation(.easeInOut(duration: 0.3)) {
									selectedOption = index
								}
							}
					}
					.padding(.horizontal, 8)
				}
			}
			
			Rectangle()
				.fill(.gray.opacity(0.2))
				.frame(height: 1)
		}
		.padding(.horizontal)
	}
}

// MARK: - SearchHistoryView
struct SearchHistoryView: View {
	let searchList: [String]
	let onSelect: ((String) -> Void)?
	let onDelete: ((String) -> Void)?
	let onClear: (() -> Void)?
	
	var body: some View {
		if searchList.isEmpty {
			EmptyView()
		}
		else {
			VStack(alignment: .leading) {
				HStack {
					Text("Recent")
						.font(.subheadline)
						.foregroundColor(.secondary)
					Spacer()
					Button("Reset") {
						onClear?()
					}
					.font(.subheadline)
					.foregroundColor(.primary)
				}
				.padding(.horizontal)
				
				let columns = [GridItem(.adaptive(minimum: 72))]
				LazyVGrid(columns: columns, alignment: .leading, spacing: 4) {
					ForEach(searchList, id: \.self) { text in
						HStack {
							Text(text)
								.font(.caption)
								.lineLimit(1)
								.truncationMode(.tail)
							Button(action: {
								onDelete?(text)
							}) {
								Image(systemName: "xmark.circle.fill")
									.foregroundColor(.secondary)
							}
						}
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(Color.gray)
						.cornerRadius(20)
						.onTapGesture {
							onSelect?(text)
						}
					}
				}
				.padding(.horizontal)
			}
			.padding(.vertical, 16)
		}
	}
}

// MARK: - SearchResult
enum ResultDisplayStyle {
	case list, segment
}

struct SearchResult: View {
	let searchResults: [String]
	let onSelect: ((String) -> Void)?
	
	@State private var resultDisplayStyle: ResultDisplayStyle = .list
	
	var body: some View {
		switch resultDisplayStyle {
		case .list:
			return AnyView(resultListView)
		case .segment:
			return AnyView(resultSegmentView)
		}
	}
	
	var resultListView: some View {
		List {
			ForEach(searchResults, id: \.self) { text in
				HStack {
					Text(text)
				}
				.onTapGesture {
					onSelect?(text)
				}
			}
		}
		.listStyle(PlainListStyle())
	}
	
	var resultSegmentView: some View {
		VStack {
			// ...
		}
	}
}

#Preview {
    SearchPreview()
}

struct SearchPreview: View {
	let store = Store(
		initialState: SearchReducer.State(),
		reducer: { SearchReducer() },
		withDependencies: {
			$0.searchDataClient = .init {
				[
					"Apple", "Google", "Microsoft", "Amazon", "Meta", "IBM", "Intel", "Oracle",
					"Samsung", "LG", "Sony", "Dell", "Cisco", "HP", "Adobe", "Salesforce",
					"Nvidia", "Qualcomm", "Spotify", "Netflix", "Uber", "Airbnb", "Snap",
					"Zoom", "Dropbox", "Slack", "Shopify", "Twitter", "Pinterest", "Reddit",
					"Stripe", "Square", "GitHub", "GitLab", "Bitbucket", "LinkedIn", "WeWork",
					"Atlassian", "VMware", "PayPal", "eBay", "Alibaba", "Tencent", "Baidu",
					"Xiaomi", "Huawei", "Lenovo", "ASUS", "Acer", "ZTE", "Panasonic", "Fujitsu",
					"Hitachi", "Toshiba", "NEC", "Naver", "Kakao", "LINE", "Coupang", "Rakuten",
					"Cloudflare", "Akamai", "Okta", "Palantir", "Snowflake", "Splunk", "Datadog",
					"MongoDB", "Elastic", "Fastly", "Nutanix", "DigitalOcean", "HPE", "Seagate",
					"Western Digital", "Kingston", "Sandisk", "ZoomInfo", "Workday", "ServiceNow",
					"Square Enix", "Unity", "Epic Games", "Electronic Arts", "Activision Blizzard",
					"Riot Games", "Valve", "Discord", "Telegram", "Viber", "Notion", "Figma",
					"Miro", "Canva", "Basecamp", "Trello", "Confluence", "Monday.com"
				]
			}
		}
	)
	
	var body: some View {
		VStack(alignment: .leading) {
			SearchView(store: store)
			Spacer()
			Divider()
			VStack(alignment: .leading) {
				Text("Search Text: \(store.state.text)")
				Text("Search Result Count: \(store.state.searchResults.count)")
			}
			.padding()
		}
	}
}
