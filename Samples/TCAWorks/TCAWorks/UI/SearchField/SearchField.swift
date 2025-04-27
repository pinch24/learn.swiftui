//  SearchField.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

public struct SearchField: View {
	@Binding var searchText: String
	@FocusState private var isTextFieldFocused: Bool
	
	var isFilterEnabled: Bool = false
	@State private var isFilterPresent: Bool = false
	
	var onSubmit: ((String) -> Void)?
	var onBack: (() -> Void)?
	var onCancel: (() -> Void)?
	
	public init(searchText: Binding<String>, isFilterEnabled: Bool = false, onSubmit: ((String) -> Void)? = nil, onBack: (() -> Void)? = nil, onCancel: (() -> Void)? = nil) {
		self._searchText = searchText
		self.isFilterEnabled = isFilterEnabled
		self.onSubmit = onSubmit
		self.onBack = onBack
		self.onCancel = onCancel
	}
	
	public var body: some View {
		HStack {
			if onBack != nil {
				backButton
			}
			HStack {
				Image(systemName: "magnifyingglass")
					.foregroundStyle(Color.gray)
				
				TextField("검색", text: $searchText)
					.focused($isTextFieldFocused)
					.textFieldStyle(PlainTextFieldStyle())
					.onSubmit {
						onSubmit?(searchText)
					}
				
				if !searchText.isEmpty {
					Button {
						searchText = ""
					} label: {
						Image(systemName: "xmark.circle.fill")
							.foregroundStyle(Color.gray)
					}
				}
			}
			.padding(16)
			.background(Color.secondary.opacity(0.4))
			.cornerRadius(16)
			
			if isFilterEnabled {
				filterButton
			}
			
			if onCancel != nil {
				cancelButton
			}
		}
	}
	
	var filterButton: some View {
		Button {
			isFilterPresent.toggle()
		} label: {
			Image(systemName: "line.3.horizontal.decrease")
				.frame(width: 16, height: 16)
				.foregroundStyle(Color.primary)
				.padding(16)
		}
		.background(Color.secondary.opacity(0.4))
		.cornerRadius(16)
		.sheet(isPresented: $isFilterPresent) {
			VStack {
				Capsule()
					.fill(Color.secondary.opacity(0.4))
					.frame(width: 44, height: 4)
					.padding(.top, 8)
					.padding(.bottom, 16)
				SearchFilter()
			}
			.presentationDetents([.fraction(0.74)])
		}
		.transition(.opacity)
		.animation(.easeInOut, value: isTextFieldFocused || !searchText.isEmpty)
	}
	
	var backButton: some View {
		Button {
			onBack?()
		} label: {
			Image(systemName: "chevron.left")
				.foregroundStyle(Color.primary)
		}
		.transition(.move(edge: .trailing).combined(with: .opacity))
		.animation(.easeInOut, value: isTextFieldFocused || !searchText.isEmpty)
	}
	
	var cancelButton: some View {
		Button {
			onCancel?()
		} label: {
			Text("취소")
				.foregroundStyle(Color.primary)
		}
		.transition(.move(edge: .trailing).combined(with: .opacity))
		.animation(.easeInOut, value: isTextFieldFocused || !searchText.isEmpty)
	}
}

#Preview {
	SearchFieldPreview()
}

private struct SearchFieldPreview: View {
	@State private var text: String = ""
	var body: some View {
		VStack {
			SearchField(searchText: $text)
		}
		.padding()
	}
}
