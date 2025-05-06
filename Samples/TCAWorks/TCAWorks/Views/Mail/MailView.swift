//
//  MailView.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Reducer
@Reducer
struct MailReducer {
	@ObservableState
	struct State: Equatable, Sendable {
		var mailListState: MailListReducer.State = .init(mailList: mailListMockData, isEditing: false)
		@Presents var mailFolderState: MailFolderReducer.State?
		
		var showFolderSheet = false
		
		var searchState: SearchReducer.State = .init(isNeedFilter: true)
		var isSearchExpand = false
		
		var isDrawerMenuOpen = false
	}

	enum Action: Equatable {
		case mailListAction(MailListReducer.Action)
		case mailFolderAction(PresentationAction<MailFolderReducer.Action>)
//		case mailNotifyAction(MailNotifyReducer.Action)
		
		case toggleFolderSheet
		
		case searchAction(SearchReducer.Action)
		case toggleSearchExpand
		
		case toggleDrawerMenu
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .toggleFolderSheet:
				state.showFolderSheet.toggle()
				state.mailFolderState = MailFolderReducer.State()
				return .none
				
			case .toggleSearchExpand:
				state.isSearchExpand.toggle()
				return .none
				
			case .searchAction(let action):
				switch action {
				case .dismiss:
					state.isSearchExpand.toggle()
					return .none
				case .updateExpanded(let value):
					state.isSearchExpand = value
					return .none
				default:
					return .none
				}
				
			case .toggleDrawerMenu:
				state.isDrawerMenuOpen.toggle()
				return .none
			
			default:
				return .none
			}
		}
		
		Scope(state: \.mailListState, action: \.mailListAction) {
			MailListReducer()
		}
		
		.ifLet(\.$mailFolderState, action: \.mailFolderAction) {
			MailFolderReducer()
		}
		
//		Scope(state: \.scopeState.mailNotifyState, action: \.scopeAction.mailNotifyAction) {
//			MailNotifyReducer()
//		}
		
		Scope(state: \.searchState, action: \.searchAction) {
			SearchReducer()
		}
	}
}

// MARK: - View
struct MailView: View {
	let store: StoreOf<MailReducer>
	private var viewStore: ViewStoreOf<MailReducer>
	
	init() {
		let store = Store(initialState: MailReducer.State(), reducer: { MailReducer() })
		self.store = store
		self.viewStore = ViewStore(self.store, observe: \.self)
	}
}

extension MailView {
	var body: some View {
		// Mail List
		MailListView(store: store.scope(state: \.mailListState, action: \.mailListAction))
			// Navigation Bar & Search Bar
			.safeAreaInset(edge: .top) {
				if viewStore.mailListState.isEditing {
					VStack {
						navigationBarEditView
						editBarView
					}
				} else {
					VStack {
						navigationBarMenuView
						searchBarView
					}
				}
			}
			// Mail Folder Sheet
//			.ifLet(\.mailFolderState, action: \.mailFoldersAction) { store in
//				MailFolderSheet(store: store)
//			}
			.sheet(store: store.scope(state: \.$mailFolderState, action: \.mailFolderAction)) { store in
				MailFolderSheet(store: store)
			}
				// Mail Notify Sheet
//				.sheet(isPresented: Binding(
//					get: { mailNotifyViewStore.show },
//					set: { _ in mailNotifyViewStore.send(.dismiss) }
//				)) {
//					let store = store.scope(state: \.scopeState.mailNotifyState, action: \.scopeAction.mailNotifyAction)
//					MailNotifySheet(store: store)
//				}
//				.transition(.opacity)
		// Search Bar Show/Hide Gesture
			.simultaneousGesture(
				DragGesture()
					.onChanged { value in
						viewStore.send(.searchAction(.updateOffset(viewStore.searchState.minY + value.translation.height)))
					}
					.onEnded { _ in
						let nextMinY = min(max(viewStore.searchState.offset, -64), 0)
						viewStore.send(.searchAction(.updateMinY(nextMinY)))
						viewStore.send(.searchAction(.updateOffset(0)))
					}
			)
				// Search Bar Expand
				.overlay {
					if viewStore.isSearchExpand {
						let store = store.scope(state: \.searchState, action: \.searchAction)
						SearchView(store: store)
							.background(Color.background)
					}
				}
//				// Drawer Menu
//				.overlay(alignment: .leading) {
//					drawerMenu
//				}
				.animation(.easeInOut(duration: 0.24), value: viewStore.mailListState.isEditing)
	}
}

extension MailView {
	private var navigationBarEditView: some View {
		NavigationBar(
			title: "N개 선택",
			type: .back,
			rightItems: [
				NavigationBarItem(iconView: AnyView(Image(systemName: "trash"))) {
					// ...
				},
				NavigationBarItem(iconView: AnyView(Image(systemName: "archivebox"))) {
					// ...
				},
				NavigationBarItem(iconView: AnyView(Image(systemName: "envelope"))) {
					// ...
				},
				
				NavigationBarItem(
					iconView: AnyView(
						Menu {
							Button("이동") {
								viewStore.send(.toggleFolderSheet)
							}
							Button("복사") {
								#warniing("<decode: bad range for [%@] got [offs:378 len:846 within:0]>")
								viewStore.send(.mailFolderAction(.presented(.toggleShow)))
							}
							Button("스팸/해킹 신고") {
									// store.send(.scopeAction(.mailNotifyAction(.viewAction(.toggleShow))))
							}
						} label: {
							Image.init(systemName: "ellipsis")
						}
						
						// 컨텍스트 메뉴
//                        ContextMenu(menuItems: [
//                            MenuItemData(title: "이동", action: {
//                                print("이동")
//                            }),
//                            MenuItemData(title: "복사", action: {
//                                print("복사")
//                            }),
//                            MenuItemData(title: "스팸/해킹 신고", action: {
//                                print("스팸/해킹 신고")
//                            }),
//                        ], label: {
//                            Images.iconMoreVertical
//                        })
					)
				),
			],
			onBack: {
				viewStore.send(.mailListAction(.toggleEditMode))
			}
		)
		.background(BlurEffect())
	}
	
	private var navigationBarMenuView: some View {
		NavigationBar(
			title: "전체 메일함",
			rightItems: [
				NavigationBarItem(iconView: AnyView(Text("편집"))) {
					viewStore.send(.mailListAction(.toggleEditMode))
				},
				NavigationBarItem(iconView: AnyView(Image(systemName: "bell"))) {
					// ...
				},
			],
			onMenu: {
				viewStore.send(.toggleDrawerMenu, animation: .easeInOut)
			}
		)
		.background(BlurEffect())
	}
	
	private var editBarView: some View {
		HStack {
			Button {
				viewStore.send(.mailListAction(.toggleSelectAllItem))
			} label: {
				HStack {
					if viewStore.mailListState.isSelectAll {
						Image(systemName: "checkmark.circle.fill")
							.foregroundStyle(.primary)
					} else {
						Image(systemName: "circle")
							.foregroundStyle(Color.primary)
					}
					
					Text("전체")
						.tint(Color.primary)
				}
				.padding()
			}
			
			Spacer()
		}
		.frame(height: 64)
	}
	
	private var searchBarView: some View {
		GeometryReader { proxy in
			VStack {
				SearchField(searchText: Binding(
					get: { "..." },
					set: { _ in }
				), isFilterEnabled: true)
				.frame(height: 64)
				.padding(.horizontal)
				.disabled(true)
				.onTapGesture {
					viewStore.send(.toggleSearchExpand)
				}
			}
			.offset(y: viewStore.searchState.height - CGFloat(64))
			.opacity(viewStore.searchState.height / CGFloat(64))
		}
		.frame(height: 64)
	}
	
	
//	private func drawerMenu(_ viewStore: ViewStore<MailReducer.State.ViewState, MailReducer.Action.ViewAction>) -> some View {
//		VStack {
//			if viewStore.isDrawerMenuOpen {
//				ZStack {
//					Color.gray.opacity(0.8)
//						.ignoresSafeArea()
//						.onTapGesture {
//							viewStore.send(.toggleDrawerMenu, animation: .easeInOut)
//						}
//
//					HStack(spacing: 0) {
//						DrawerMenu(
//							isDrawerMenuOpen: Binding(
//								get: { viewStore.isDrawerMenuOpen },
//								set: { _ in viewStore.send(.toggleDrawerMenu) }
//							),
//							menuBoxes: [
//								.init(icon: Image(systemName: "envelope"), name: "전체 메일함", count: 11),
//								.init(icon: Image(systemName: "tray"), name: "받은 메일함", count: 999),
//								.init(icon: Image(systemName: "envelope.front"), name: "보낸 메일함", count: 6),
//								.init(icon: Image(systemName: "square.and.pencil"), name: "임시 보관함", count: 1),
//								.init(icon: Image(systemName: "archivebox"), name: "보관 메일함", count: 90),
//								.init(icon: Image(systemName: "xmark.bin.fill"), name: "스팸 메일함", count: 90),
//								.init(icon: Image(systemName: "trash"), name: "휴지통", count: 90, trailingAction: ("비우기", {}))
//							],
//							menuFolders: []
//						)
//						.frame(width: 280)
//						.background(Color.background)
//						.transition(.move(edge: .leading))
//
//						Spacer()
//					}
//				}
//			}
//		}
//	}
}

#Preview {
	Mail_Preview()
}

struct Mail_Preview: View {
	var body: some View {
		MailView()
	}
}
