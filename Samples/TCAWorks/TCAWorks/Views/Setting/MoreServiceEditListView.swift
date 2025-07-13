//
//  MoreServiceEditListView.swift
//  TCAWorks
//
//  Created by MK on 7/13/25.
//

import SwiftUI
import ComposableArchitecture
import Perception

struct MoreServiceEditListView: View {
	typealias ViewState = MoreServiceEditReducer.State.ViewState
	typealias ViewAction = MoreServiceEditReducer.Action.ViewAction
	//@ObservedObject private var viewStore: ViewStore<ViewState, ViewAction>
	//@StateObject private var viewStore: ViewStore<ViewState, ViewAction>
	private let store: StoreOf<MoreServiceEditReducer>
	init(store: StoreOf<MoreServiceEditReducer>) {
		print("init(store:)")
		self.store = store
//        self.viewStore = ViewStore(
//            store,
//            observe: { $0.viewState },
//            send: { .viewAction($0) }
//        )
//        self._viewStore = StateObject(wrappedValue: ViewStore(
//            store,
//            observe: { $0.viewState },
//            send: { .viewAction($0) }
//        ))
	}
	
	var body: some View {
		VStack(spacing: 0) {
			header
				.padding(.horizontal)
				.padding(.vertical, 12)
			
			Text("Sections: \(store.state.viewState.menuSections.count)")
				.padding()
			
			Button {
				store.send(.viewAction(.onAppear))
			} label: {
				Text("ON APPEAR")
			}
			
			Text("Count: \(store.state.viewState.count)")
				
			
			List {
				ForEach(store.state.viewState.menuSections) { section in
					Section {
						ForEach(section.menuItems) { item in
							MenuItemRow(menuItem: item)
								.listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
								.listRowSeparator(.hidden)
								.listRowBackground(Color.clear)
						}
						.onMove { indices, newOffset in
							handleMove(in: section, from: indices, to: newOffset)
						}
						
						if section.menuItems.isEmpty {
							EmptyPlaceholder()
								.listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
								.listRowSeparator(.hidden)
								.listRowBackground(Color.clear)
						}
					} header: {
						Text(section.title)
							.foregroundStyle(Color.secondary)
							.textCase(nil)
							.listRowInsets(EdgeInsets())
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.environment(\.editMode, .constant(.active))
			.scrollContentBackground(.hidden)
			.background(Color.gray.opacity(0.02))
		}
		.onAppear {
			print("onAppear")
			store.send(.viewAction(.onAppear))
		}
	}
	
	var header: some View {
		Button {
			store.send(.viewAction(.dismiss))
		} label: {
			HStack {
				Image(systemName: "chevron.left")
				Text("순서편집")
					.foregroundStyle(Color.primary)
				Spacer()
			}
		}
	}
	
	private func handleMove(in section: ServiceMenuSection, from source: IndexSet, to destination: Int) {
		var updatedItems = section.menuItems
		updatedItems.move(fromOffsets: source, toOffset: destination)
		store.send(.viewAction(.updateMenuSection(sectionId: section.id, menuItems: updatedItems)))
	}
}

struct MenuItemRow: View {
	let menuItem: ServiceMenuItem
	
	var body: some View {
		HStack(spacing: 12) {
			if let image = menuItem.image {
				image
					.renderingMode(.template)
					.foregroundStyle(Color.primary)
			}
			
			Text(menuItem.title)
				.foregroundStyle(Color.primary)
			
			Spacer()
		}
		.padding(.horizontal, 16)
		.padding(.vertical, 12)
		.background(
			RoundedRectangle(cornerRadius: 8)
				.stroke(Color.primary, lineWidth: 1)
				.background(
					RoundedRectangle(cornerRadius: 8)
						.fill(Color.primary.opacity(0.02))
				)
		)
	}
}

struct EmptyPlaceholder: View {
	var body: some View {
		Text("...")
			.foregroundStyle(Color.secondary)
			.frame(maxWidth: .infinity)
			.padding(.vertical, 20)
	}
}

#Preview {
	MoreServiceEditListView(
		store: Store(
			initialState: MoreServiceEditReducer.State(),
			reducer: { MoreServiceEditReducer() }
		)
	)
}
