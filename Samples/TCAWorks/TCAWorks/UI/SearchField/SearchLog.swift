//
//  SearchLog.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

struct SearchLog: View {
	let searchList: [String]
	let onSelect: ((String) -> Void)?
	let onDelete: ((String) -> Void)?
	let onClear: (() -> Void)?
	
	init(searchList: [String], onSelect: ((String) -> Void)? = nil, onDelete: ((String) -> Void)? = nil, onClear: (() -> Void)? = nil) {
		self.searchList = searchList
		self.onSelect = onSelect
		self.onDelete = onDelete
		self.onClear = onClear
	}
	
	var body: some View {
		if searchList.isEmpty {
			EmptyView()
		} else {
			VStack(alignment: .leading) {
				HStack {
					Text("최근")
						.foregroundStyle(Color.gray)
					Spacer()
					Button("전체 삭제") {
						onClear?()
					}
					.foregroundStyle(Color.gray)
				}
				.padding(.horizontal)
				
				// Chip List
				let columns = [GridItem(.adaptive(minimum: 72))]
				
				LazyVGrid(columns: columns,
						  alignment: .leading,
						  spacing: 4
				) {
					ForEach(searchList, id: \.self) { text in
						HStack {
							Text(text)
								.font(.caption)
								.lineLimit(1)
								.truncationMode(.tail)
							Button {
								onDelete?(text)
							} label: {
								Image(systemName: "xmark.circle.fill")
									.foregroundStyle(Color.gray)
							}
						}
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(Color.gray)
						.cornerRadius(16)
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

#Preview {
	SearchLogPreview()
}

private struct SearchLogPreview: View {
	@State private var list: [String] = [
		"apple", "banana", "cherry", "orange", "pineapple"
	]
	var body: some View {
		VStack {
			SearchLog(searchList: list,
					  onSelect: { text in
						print(text)
					  },
					  onDelete: { text in
						list.removeAll { $0 == text }
					  },
					  onClear: {
						list.removeAll()
					  }
			)
		}
		.padding()
	}
}
