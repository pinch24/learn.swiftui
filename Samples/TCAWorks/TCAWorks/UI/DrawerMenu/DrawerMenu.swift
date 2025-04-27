//
//  DrawerMenu.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI

struct DrawerMenu: View {
	@Binding var isDrawerMenuOpen: Bool
	
	var menuSpaces: [MenuSpace]?
	var menuHeader: [MenuHeader]?
	var menuBoxes: [MenuBox]
	
	@State var menuFolders: [MenuFolder]
	private var visibleFolders: [MenuFolder] {
		func collect(from parent: String?) -> [MenuFolder] {
			var result: [MenuFolder] = []
			for item in menuFolders.filter({ $0.parent == parent }) {
				result.append(item)
				if item.isExpanded {
					result.append(contentsOf: collect(from: item.id))
				}
			}
			return result
		}
		return collect(from: nil)
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			spaceMenu

			headerMenu
				.padding(.bottom, 16)
			
			ScrollView {
				listMenu
					.padding(.bottom, 16)
				
				folderMenu
				
				Spacer()
			}
			.scrollIndicators(.hidden)
		}
		.padding()
	}
	
	var spaceMenu: some View {
		VStack(alignment: .leading, spacing: 16) {
			if let menuSpaces {
				Menu {
					ForEach(menuSpaces) { item in
						Button {
							item.action?()
							isDrawerMenuOpen = false
						} label: {
							Text(item.name)
								.foregroundStyle(Color.primary)
						}
					}
				} label: {
					HStack {
						Text(menuSpaces.first?.name ?? "메일")
							.foregroundStyle(Color.primary)
						Image(systemName: "chevron.up.chevron.down")
							.tint(.primary)
						Spacer()
					}
				}
			} else {
				Text("메일")
			}
		}
	}
	
	var headerMenu: some View {
		VStack(alignment: .leading, spacing: 16) {
			HStack(spacing: 32) {
				if let menuHeader {
					ForEach(menuHeader) { item in
						Button {
							item.action?()
							isDrawerMenuOpen = false
						} label: {
							VStack(spacing: 4) {
								item.icon
									.foregroundStyle(Color.primary)
								Text(item.name)
									.foregroundStyle(Color.secondary)
							}
						}
					}
				}
			}
			.padding(.leading, 32)
		}
	}
	
	var listMenu: some View {
		VStack(alignment: .leading, spacing: 16) {
			ForEach(menuBoxes) { item in
				HStack {
					Button {
						item.action?()
						isDrawerMenuOpen = false
					} label: {
						HStack {
							item.icon
								.tint(Color.primary)
								.frame(width: 24, height: 24)
							Text(item.name)
								.foregroundStyle(Color.primary)
								.frame(width: 82, height: 24, alignment: .leading)
							Text("\(item.count)")
								.foregroundStyle(Color.secondary)
						}
					}
					
					if let (name, action) = item.trailingAction {
						Spacer()
						Button {
							action()
						} label: {
							Text(name)
								.padding(.horizontal, 5)
								.padding(.vertical, 4)
								.foregroundStyle(Color.secondary)
								.background(Color.secondary.opacity(0.4))
								.cornerRadius(4)
						}
					}
				}
			}
			
			Divider()
		}
	}
	
	var folderMenu: some View {
		VStack(alignment: .leading, spacing: 16) {
			HStack {
				Text("내 메일함")
					.foregroundStyle(Color.primary)
				
				Button {
					// ...
				} label: {
					Text("폴더 추가")
						.padding(.horizontal, 5)
						.padding(.vertical, 4)
						.foregroundStyle(Color.secondary)
						.background(Color.secondary.opacity(0.4))
						.cornerRadius(4)
				}
			}
			
			ForEach(visibleFolders) { item in
				HStack {
					Button {
						item.action?()
						isDrawerMenuOpen = false
					} label: {
						HStack {
							Color.clear.frame(width: 24 * CGFloat(item.depth))
							item.icon
								.tint(Color.primary)
								.frame(width: 24, height: 24)
							Text(item.lastName)
								.foregroundStyle(Color.primary)
								.frame(height: 24, alignment: .leading)
							
							if item.count > 0 {
								Text("\(item.count)")
									.foregroundStyle(Color.secondary)
							}
						}
					}
					
					Spacer()
					
					// 하위 폴더 유무 체크
					if menuFolders.filter({ $0.parent == item.id }).count > 0 {
						Button {
							// 폴더 확장 토글
							if let index = menuFolders.firstIndex(where: { $0.id == item.id }) {
								withAnimation {
									menuFolders[index].isExpanded.toggle()
								}
							}
						} label: {
							// 폴더 확장/축소 아이콘
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
		.animation(.easeInOut(duration: 0.2), value: visibleFolders)
	}
}

struct MenuSpace: Identifiable {
	let id = UUID()
	let name: String
	let action: (() -> Void)? = nil
}

struct MenuHeader: Identifiable {
	let id = UUID()
	let name: String
	let icon: AnyView
	let action: (() -> Void)? = nil
}

struct MenuBox: Identifiable {
	let id = UUID()
	let icon: Image
	let name: String
	let count: Int
	let action: (() -> Void)?
	let trailingAction: (String, () -> Void)?
	
	init(icon: Image, name: String, count: Int, action: (() -> Void)? = nil, trailingAction: (String, () -> Void)? = nil) {
		self.icon = icon
		self.name = name
		self.count = count
		self.action = action
		self.trailingAction = trailingAction
	}
}

struct MenuFolder: Identifiable, Equatable {
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
	
	static func == (lhs: MenuFolder, rhs: MenuFolder) -> Bool {
		return lhs.id == rhs.id &&
			   lhs.count == rhs.count &&
			   lhs.isExpanded == rhs.isExpanded
	}
	
	var lastName: String { name.components(separatedBy: "/").last ?? name }
	var depth: Int { name.filter { $0 == "/" }.count }
}

#Preview {
	MailMenuPreview()
}

struct MailMenuPreview: View {
	@State private var isDrawerMenuOpen = false
	let menuSpaceItems: [MenuSpace] = [
		.init(name: "내 메일함"),
		.init(name: "두레이 공용 메일함"),
		.init(name: "김고은 공용메일(공개)"),
		.init(name: "김고은 공용메일(비공개)"),
	]
	let menuHeaderItems: [MenuHeader] = [
		.init(name: "안 읽음", icon: AnyView(Text("999+"))),
		.init(name: "중요 메일", icon: AnyView(Image(systemName: "star"))),
		.init(name: "첨부 메일", icon: AnyView(Image(systemName: "paperclip"))),
	]
	let menuBoxItems: [MenuBox] = [
		.init(icon: Image(systemName: "envelope"), name: "전체 메일함", count: 11),
		.init(icon: Image(systemName: "tray"), name: "받은 메일함", count: 999),
		.init(icon: Image(systemName: "envelope.front"), name: "보낸 메일함", count: 6),
		.init(icon: Image(systemName: "square.and.pencil"), name: "임시 보관함", count: 1),
		.init(icon: Image(systemName: "archivebox"), name: "보관 메일함", count: 90),
		.init(icon: Image(systemName: "xmark.bin.fill"), name: "스팸 메일함", count: 90),
		.init(icon: Image(systemName: "trash"), name: "휴지통", count: 90, trailingAction: ("비우기", {}))
	]
	let menuFolderItems: [MenuFolder] = [
		.init(id: "0", icon: Image(systemName: "folder"), name: "루트", count: 12, parent: nil),
		.init(id: "1", icon: Image(systemName: "folder"), name: "루트/1 메뉴", count: 0, parent: "0"),
		.init(id: "1-1", icon: Image(systemName: "folder"), name: "루트/1 메뉴/1-1 메뉴", count: 0, parent: "1"),
		.init(id: "1-2", icon: Image(systemName: "folder"), name: "루트/1 메뉴/1-2 메뉴", count: 1, parent: "1"),
		.init(id: "2", icon: Image(systemName: "folder"), name: "루트/2 메뉴", count: 3, parent: "0"),
		.init(id: "2-1", icon: Image(systemName: "folder"), name: "루트/2 메뉴/2-1 메뉴", count: 4, parent: "2"),
		.init(id: "2-2", icon: Image(systemName: "folder"), name: "루트/2 메뉴/2-2 메뉴", count: 999, parent: "2"),
		
		.init(id: "SINGLE", icon: Image(systemName: "folder"), name: "싱글", count: 0, parent: nil),
		.init(id: "DOUBLE", icon: Image(systemName: "folder"), name: "싱글/더블", count: 0, parent: "SINGLE"),
		.init(id: "TERNARY", icon: Image(systemName: "folder"), name: "싱글/터너리", count: 0, parent: "SINGLE"),
		.init(id: "QUANTERNARY", icon: Image(systemName: "folder"), name: "싱글/터너리/퀀터리", count: 0, parent: "TERNARY"),
	]
	var body: some View {
		DrawerMenu(
			isDrawerMenuOpen: $isDrawerMenuOpen,
			menuSpaces: menuSpaceItems,
			menuHeader: menuHeaderItems,
			menuBoxes: menuBoxItems,
			menuFolders: menuFolderItems
		)
	}
}
