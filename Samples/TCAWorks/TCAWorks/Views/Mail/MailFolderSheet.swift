//
//  MailFolderSheet.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MailFolderReducer {
	@ObservableState
	struct State: Equatable, Sendable {
		var show: Bool = false
		var selectedMailBox: MailBoxType = .inbox
		
		var mailFolders: [MailFolder] = [
			.init(id: "0", icon: Image(systemName: "folder"), name: "하모니, 결재", count: 0, parent: nil),
			.init(id: "1", icon: Image(systemName: "folder"), name: "하모니, 결재/하위폴더1", count: 0, parent: "0"),
		]
		var visibleFolders: [MailFolder] {
			func collect(from parent: String?) -> [MailFolder] {
				var result: [MailFolder] = []
				for item in mailFolders.filter({ $0.parent == parent }) {
					result.append(item)
					if item.isExpanded {
						result.append(contentsOf: collect(from: item.id))
					}
				}
				return result
			}
			return collect(from: nil)
		}
	}
	
	enum Action: Equatable {
		case dismiss
		case toggleShow
		case expandFolder(Int)
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .dismiss:
				state.show = false
				return .none
			case .toggleShow:
				state.show.toggle()
				return .none
			case .expandFolder(let index):
				state.mailFolders[index].isExpanded.toggle()
				return .none
			}
		}
	}
}

enum MailBoxType: CaseIterable {
	case inbox, sent, archived, spam, deleted
	
	var name: String {
		switch self {
		case .inbox:
			"받은 메일함"
		case .sent:
			"보낸 메일함"
		case .archived:
			"보관 메일함"
		case .spam:
			"스팸 메일함"
		case .deleted:
			"휴지통"
		}
	}
	
	var image: Image {
		switch self {
		case .inbox:
			Image(systemName: "tray")
		case .sent:
			Image(systemName: "envelope.front")
		case .archived:
			Image(systemName: "archivebox")
		case .spam:
			Image(systemName: "xmark.bin.fill")
		case .deleted:
			Image(systemName: "trash")
		}
	}
}

struct MailFolder: Identifiable, Equatable {
	let id: String
	let icon: Image
	let name: String
	let count: Int
	let parent: String?
	var isExpanded: Bool
	let action: (() -> Void)?
	let trailingAction: (String, () -> Void)?
	
	init(id: String, icon: Image, name: String, count: Int, parent: String?, isExpanded: Bool = false, action: (() -> Void)? = nil, trailingAction: (String, () -> Void)? = nil) {
		self.id = id
		self.icon = icon
		self.name = name
		self.count = count
		self.parent = parent
		self.isExpanded = isExpanded
		self.action = action
		self.trailingAction = trailingAction
	}
	
	static func == (lhs: MailFolder, rhs: MailFolder) -> Bool {
		return lhs.id == rhs.id &&
			   lhs.count == rhs.count &&
			   lhs.isExpanded == rhs.isExpanded
	}
	
	var lastName: String { name.components(separatedBy: "/").last ?? name }
	var depth: Int { name.filter { $0 == "/" }.count }
}

// MARK: - View
struct MailFolderSheet: View {
	let store: StoreOf<MailFolderReducer>
	private var viewStore: ViewStoreOf<MailFolderReducer>
	
	init(store: StoreOf<MailFolderReducer>) {
		self.store = store
		self.viewStore = .init(store, observe: \.self)
	}
	
	var body: some View {
		VStack {
			Capsule()
				.fill(Color.secondary)
				.frame(width: 40, height: 4)
				.padding(.top, 8)
				.padding(.bottom, 28)
			
			VStack(alignment: .leading) {
				Text("메일이동")
					.foregroundStyle(Color.primary)
					.padding(.bottom, 20)
				
				SearchField(searchText: .constant(""))
					.padding(.bottom, 28)
				
				mailBoxes
				
				Divider()
					.padding(.bottom, 10)
				
				myMailBoxes
					.padding(.bottom, 28)
				
				
				HStack {
					Button {
						// ...
					} label: {
						Text("취소")
							.tint(.secondary)
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 16)
									.stroke(Color.secondary, lineWidth: 2)
									.background(Color.white.cornerRadius(16))
							)
					}
					
					Button {
						// ...
					} label: {
						Text("신고")
							.tint(.primary)
							.padding()
							.background(
								RoundedRectangle(cornerRadius: 16)
									.stroke(Color.secondary, lineWidth: 2)
									.background(Color.white.cornerRadius(16))
							)
					}
				}
				.frame(maxWidth: .infinity, alignment: .center)
			}
			
			Spacer()
		}
		.padding(.horizontal, 24)
		.presentationDetents([.fraction(0.84)])
	}
	
	var mailBoxes: some View {
		VStack(alignment: .leading) {
			Text("메일함")
				.foregroundStyle(Color.gray)
				.padding(.bottom, 10)
			
			ForEach(MailBoxType.allCases, id: \.self) { item in
				HStack {
					item.image
						.renderingMode(.template)
					Text(item.name)
					Spacer()
					if viewStore.selectedMailBox == item {
						Image.init(systemName: "checkmark.circle.fill")
							.renderingMode(.template)
							.foregroundStyle(Color.accentColor)
					}
				}
				.frame(height: 44)
				.foregroundStyle(viewStore.selectedMailBox == item ? Color.accentColor : Color.primary)
			}
		}
	}
	
	var myMailBoxes: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("내 메일함")
					.foregroundStyle(Color.teal)
			}
			
			ForEach(viewStore.visibleFolders) { item in
				HStack {
					Button {
						// ...
					} label: {
						HStack {
							Color.clear.frame(width: 24 * CGFloat(item.depth))
							item.icon
								.tint(Color.primary)
								.frame(width: 24,
									   height: 24
								)
							Text(item.lastName)
								.foregroundStyle(Color.primary)
								.frame(height: 24,
									   alignment: .leading
								)
							
							if item.count > 0 {
								Text("\(item.count)")
									.foregroundStyle(Color.accentColor)
							}
						}
					}
					
					Spacer()
					
					// Check Sub Folder
					if viewStore.mailFolders.filter({ $0.parent == item.id }).count > 0 {
						Button {
							// Toggle Folder Expand
							if let index = viewStore.mailFolders.firstIndex(where: { $0.id == item.id }) {
								viewStore.send(.expandFolder(index), animation: .easeInOut)
							}
						} label: {
							// Folder Chevron Bullet
							Group {
								if item.isExpanded {
									Image(systemName: "chevron.up")
								} else {
									Image(systemName: "chevron.down")
								}
							}
							.tint(.primary)
						}
					}
				}
			}
		}
		.frame(height: 44 * CGFloat(viewStore.visibleFolders.count))
		.animation(.easeInOut(duration: 0.2), value: viewStore.visibleFolders)
	}
}
#Preview {
	let store = Store(initialState: MailFolderReducer.State(), reducer: { MailFolderReducer() })
	MailFolderSheet(store: store)
}
