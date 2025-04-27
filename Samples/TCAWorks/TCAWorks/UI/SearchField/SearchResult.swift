//
//  SearchResult.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

struct SearchResult: View {
	let list: [String]
	let onSelect: ((String) -> Void)?
	@State private var resultDisplayStyle: ResultDisplayStyle = .list
	
	init(list: [String], onSelect: ((String) -> Void)? = nil, resultDisplayStyle: ResultDisplayStyle = .list) {
		self.list = list
		self.onSelect = onSelect
		self.resultDisplayStyle = resultDisplayStyle
	}
	
	var body: some View {
		switch resultDisplayStyle {
		case .list: AnyView(resultListView)
		case .segment: AnyView(resultSegmentView)
		}
	}
	
	var resultListView: some View {
		List {
			ForEach(list, id: \.self) { item in
				HStack {
					Text(item)
				}
				.onTapGesture {
					onSelect?(item)
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

enum ResultDisplayStyle {
	case list, segment
}

#Preview {
	SearchResultPreview()
}

private struct SearchResultPreview: View {
	@State private var list: [String] = [
		"apple", "banana", "cherry", "orange", "pineapple"
	]
	var body: some View {
		VStack {
			SearchResult(list: list)
		}
		.padding()
	}
}
