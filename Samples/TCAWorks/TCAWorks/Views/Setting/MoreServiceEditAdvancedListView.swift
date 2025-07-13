//
//  MoreServiceEditAdvancedListView.swift
//  TCAWorks
//
//  Created by MK on 7/13/25.
//

import SwiftUI
import ComposableArchitecture
import UniformTypeIdentifiers

struct MoreServiceEditAdvancedListView: View {
	@State private var draggedItem: ServiceMenuItem?
	
	typealias ViewState = MoreServiceEditReducer.State.ViewState
	typealias ViewAction = MoreServiceEditReducer.Action.ViewAction
	@StateObject private var viewStore: ViewStore<ViewState, ViewAction>
	private let store: StoreOf<MoreServiceEditReducer>
	init(store: StoreOf<MoreServiceEditReducer>) {
		self.store = store
		self._viewStore = StateObject(wrappedValue: ViewStore(
			store,
			observe: { $0.viewState },
			send: { .viewAction($0) }
		))
	}
	
	var body: some View {
		VStack(spacing: 0) {
			header
				.padding(.horizontal)
				.padding(.vertical, 12)
			
			List {
				ForEach(viewStore.menuSections) { section in
					Section {
						ForEach(section.menuItems) { item in
							MenuItemRowDraggable(
								menuItem: item,
								sectionId: section.id,
								draggedItem: $draggedItem,
								viewStore: viewStore
							)
							.listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
							.listRowSeparator(.hidden)
							.listRowBackground(Color.clear)
						}
						.onMove { indices, newOffset in
							handleMove(in: section, from: indices, to: newOffset)
						}
						
						if section.menuItems.isEmpty {
							EmptyDropArea(section: section, draggedItem: $draggedItem, viewStore: viewStore)
								.listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
								.listRowSeparator(.hidden)
								.listRowBackground(Color.clear)
						}
					} header: {
						SectionHeader(section: section, draggedItem: $draggedItem, viewStore: viewStore)
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.environment(\.editMode, .constant(.active))
			.scrollContentBackground(.hidden)
			.background(Color.gray.opacity(0.02))
		}
		.onAppear {
			viewStore.send(.onAppear)
		}
	}
	
	var header: some View {
		Button {
			viewStore.send(.dismiss)
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
		viewStore.send(.updateMenuSection(sectionId: section.id, menuItems: updatedItems))
	}
}

struct SectionHeader: View {
	let section: ServiceMenuSection
	@Binding var draggedItem: ServiceMenuItem?
	let viewStore: ViewStore<MoreServiceEditReducer.State.ViewState, MoreServiceEditReducer.Action.ViewAction>
	
	var body: some View {
		HStack {
			Text(section.title)
				.foregroundStyle(Color.secondary)
				.textCase(nil)
			Spacer()
		}
		.padding(.vertical, 8)
		.onDrop(of: [.text], delegate: SectionDropDelegate(
			section: section,
			draggedItem: $draggedItem,
			viewStore: viewStore
		))
	}
}

struct MenuItemRowDraggable: View {
	let menuItem: ServiceMenuItem
	let sectionId: UUID
	@Binding var draggedItem: ServiceMenuItem?
	let viewStore: ViewStore<MoreServiceEditReducer.State.ViewState, MoreServiceEditReducer.Action.ViewAction>
	
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
						.fill(Color.gray.opacity(0.02))
				)
		)
		.opacity(draggedItem?.id == menuItem.id ? 0.5 : 1.0)
		.onDrag {
			self.draggedItem = menuItem
			return NSItemProvider(object: menuItem.id.uuidString as NSString)
		}
		.onDrop(of: [.text], delegate: ItemDropDelegate(
			destinationItem: menuItem,
			destinationSection: viewStore.menuSections.first { $0.menuItems.contains { $0.id == menuItem.id } } ?? ServiceMenuSection(id: UUID(), title: "", menuItems: []),
			draggedItem: $draggedItem,
			viewStore: viewStore
		))
	}
}

struct EmptyDropArea: View {
	let section: ServiceMenuSection
	@Binding var draggedItem: ServiceMenuItem?
	let viewStore: ViewStore<MoreServiceEditReducer.State.ViewState, MoreServiceEditReducer.Action.ViewAction>
	
	var body: some View {
		Text("...")
			.foregroundStyle(Color.secondary)
			.frame(maxWidth: .infinity)
			.padding(.vertical, 20)
			.onDrop(of: [.text], delegate: EmptyDropDelegate(
				section: section,
				draggedItem: $draggedItem,
				viewStore: viewStore
			))
	}
}

struct ItemDropDelegate: DropDelegate {
	let destinationItem: ServiceMenuItem
	let destinationSection: ServiceMenuSection
	@Binding var draggedItem: ServiceMenuItem?
	let viewStore: ViewStore<MoreServiceEditReducer.State.ViewState, MoreServiceEditReducer.Action.ViewAction>
	
	func validateDrop(info: DropInfo) -> Bool {
		print("Validating drop for item: \(destinationItem.title)")
		return info.hasItemsConforming(to: [.text])
	}
	
	func dropEntered(info: DropInfo) {
		print("Drop entered for item: \(destinationItem.title)")
		// Optional: Add visual feedback when hovering
	}
	
	func performDrop(info: DropInfo) -> Bool {
		print("Performing drop for item: \(destinationItem.title)")
		guard let draggedItem = draggedItem else { return false }
		
		let sourceSection = viewStore.menuSections.first { section in
			section.menuItems.contains { $0.id == draggedItem.id }
		}
		
		guard let sourceSection = sourceSection else { return false }
		
		if sourceSection.id == destinationSection.id {
			var updatedItems = destinationSection.menuItems
			guard let fromIndex = updatedItems.firstIndex(where: { $0.id == draggedItem.id }),
				  let toIndex = updatedItems.firstIndex(where: { $0.id == destinationItem.id }) else { return false }
			
			updatedItems.move(fromOffsets: IndexSet(integer: fromIndex),
							  toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
			viewStore.send(.updateMenuSection(sectionId: destinationSection.id, menuItems: updatedItems))
		} else {
			var sourceItems = sourceSection.menuItems
			sourceItems.removeAll { $0.id == draggedItem.id }
			viewStore.send(.updateMenuSection(sectionId: sourceSection.id, menuItems: sourceItems))
			
			var destItems = destinationSection.menuItems
			if let index = destItems.firstIndex(where: { $0.id == destinationItem.id }) {
				destItems.insert(draggedItem, at: index)
			}
			viewStore.send(.updateMenuSection(sectionId: destinationSection.id, menuItems: destItems))
		}
		
		self.draggedItem = nil
		return true
	}
}

struct SectionDropDelegate: DropDelegate {
	let section: ServiceMenuSection
	@Binding var draggedItem: ServiceMenuItem?
	let viewStore: ViewStore<MoreServiceEditReducer.State.ViewState, MoreServiceEditReducer.Action.ViewAction>
	
	func validateDrop(info: DropInfo) -> Bool {
		print("Validating drop for section: \(section.title)")
		return info.hasItemsConforming(to: [.text])
	}
	
	func dropEntered(info: DropInfo) {
		print("Drop entered for section: \(section.title)")
		// Optional: Add visual feedback when hovering
	}
	
	func performDrop(info: DropInfo) -> Bool {
		print("Performing drop for section: \(section.title)")
		guard let draggedItem = draggedItem else { return false }
		
		let sourceSection = viewStore.menuSections.first { section in
			section.menuItems.contains { $0.id == draggedItem.id }
		}
		
		guard let sourceSection = sourceSection,
			  sourceSection.id != section.id else { return false }
		
		var sourceItems = sourceSection.menuItems
		sourceItems.removeAll { $0.id == draggedItem.id }
		viewStore.send(.updateMenuSection(sectionId: sourceSection.id, menuItems: sourceItems))
		
		var destItems = section.menuItems
		destItems.append(draggedItem)
		viewStore.send(.updateMenuSection(sectionId: section.id, menuItems: destItems))
		
		self.draggedItem = nil
		return true
	}
}

struct EmptyDropDelegate: DropDelegate {
	let section: ServiceMenuSection
	@Binding var draggedItem: ServiceMenuItem?
	let viewStore: ViewStore<MoreServiceEditReducer.State.ViewState, MoreServiceEditReducer.Action.ViewAction>
	
	func validateDrop(info: DropInfo) -> Bool {
		print("Validating drop for empty area in section: \(section.title)")
		return info.hasItemsConforming(to: [.text])
	}
	
	func dropEntered(info: DropInfo) {
		print("Drop entered for empty area in section: \(section.title)")
		// Optional: Add visual feedback when hovering
	}
	
	func performDrop(info: DropInfo) -> Bool {
		print("Performing drop for empty area in section: \(section.title)")
		guard let draggedItem = draggedItem else { return false }
		
		let sourceSection = viewStore.menuSections.first { section in
			section.menuItems.contains { $0.id == draggedItem.id }
		}
		
		guard let sourceSection = sourceSection else { return false }
		
		var sourceItems = sourceSection.menuItems
		sourceItems.removeAll { $0.id == draggedItem.id }
		viewStore.send(.updateMenuSection(sectionId: sourceSection.id, menuItems: sourceItems))
		
		var destItems = section.menuItems
		destItems.append(draggedItem)
		viewStore.send(.updateMenuSection(sectionId: section.id, menuItems: destItems))
		
		self.draggedItem = nil
		return true
	}
}

#Preview {
	MoreServiceEditAdvancedListView(
		store: Store(
			initialState: MoreServiceEditReducer.State(),
			reducer: { MoreServiceEditReducer() }
		)
	)
}
