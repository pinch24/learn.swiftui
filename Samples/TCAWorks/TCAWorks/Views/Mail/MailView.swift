//
//  MailView.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI
import ComposableArchitecture

public struct MailView: View {
	@State private var showNotifySheet: Bool = false
	@State private var showMailMoveSheet: Bool = false
	@State private var searchViewMinY: CGFloat = .zero
	@State private var searchViewOffset: CGFloat = .zero
	
	private var calcSearchViewHeight: CGFloat {
		if searchViewOffset <= 0 {
			// Drage Up
			return max(searchViewMinY + searchViewOffset + 64, 0)
		} else {
			// Drag Down
			if searchViewMinY >= 0 {
				return 64
			}
			return min(searchViewOffset, 64)
		}
	}
	
	private let store: StoreOf<MailReducer>
	init(store: StoreOf<MailReducer>) {
		self.store = store
	}
	
	public var body: some View {
		WithViewStore(
			store.scope(
				state: \.viewState,
				action: \.viewAction
			),
			observe: { $0 }
		) { viewStore in
			ZStack {
				// 네비게이션 바
				navigationBarView(viewStore)
					.zIndex(4)
				
				// 컨텍스트 메뉴
				let store = store.scope(state: \.contextMenuState, action: \.contextMenuAction)
				contextMenuView(store)
					.zIndex(5)
				
				// 편집 모드 전체 버튼 or 일반 모드 검색 바
				headerView(viewStore)
					.zIndex(viewStore.isSearchFieldOpen ? 3 : 2)
					.offset(y: -14)		// UI 버그 - 패딩으로 뜨는 영역 있음
				
				// 본문 리스트
				MailList(viewStore: viewStore)
					.simultaneousGesture(
						DragGesture()
							.onChanged { value in
								searchViewOffset = searchViewMinY + value.translation.height
							}
							.onEnded { value in
								searchViewMinY = min(max(searchViewOffset, -64), 0)
								searchViewOffset = 0
							}
					)
					.sheet(isPresented: $showNotifySheet) {
						MailNotifySheet()
					}
					.sheet(isPresented: $showMailMoveSheet) {
						MailMoveSheet()
					}
					.transition(.opacity)
					.zIndex(1)
				
				// 서랍장 메뉴
				drawerMenu(viewStore)
					.zIndex(9)
			}
			.animation(.easeInOut(duration: 0.24), value: viewStore.isEditMode)
		}
	}
}

// MARK: - 네비게이션바, 전체 선택 버튼, 서랍장 메뉴
extension MailView {
	private func navigationBarView(_ viewStore: ViewStore<MailReducer.State.ViewState, MailReducer.Action.ViewAction>) -> some View {
		VStack {
			if viewStore.isEditMode {
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
										print("이동")
										showMailMoveSheet.toggle()
									}
									Button("복사") {
										print("복사")
										showMailMoveSheet.toggle()
									}
									Button("스팸/해킹 신고") {
										print("스팸/해킹 신고")
										showNotifySheet.toggle()
									}
								} label: {
									Image(systemName: "ellipsis")
										.rotationEffect(.degrees(90))
								}
							)
						),
						NavigationBarItem(
							iconView: AnyView(
								Button {
									let store = store.scope(state: \.contextMenuState, action: \.contextMenuAction)
									store.send(.viewAction(.showToggle))
								} label: {
									Image(systemName: "ellipsis")
										.rotationEffect(.degrees(90))
								}.overlay(ContextMenu.geometryReader { frame in
									let store = store.scope(state: \.contextMenuState, action: \.contextMenuAction)
									store.send(.viewAction(.setFrame(frame)))
								})
							)
						),
					],
					onBack: {
						viewStore.send(.toggleEditMode)
					}
				)
				.background(BlurEffect())
			} else {
				NavigationBar(
					title: "전체 메일함",
					rightItems: [
						NavigationBarItem(iconView: AnyView(Text("편집"))) {
							viewStore.send(.toggleEditMode)
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
			
			Spacer()
		}
	}
	
	private func headerView(_ viewStore: ViewStore<MailReducer.State.ViewState, MailReducer.Action.ViewAction>) -> some View {
		GeometryReader { proxy in
			VStack {
				Color.clear.frame(height: 64)
				if viewStore.isEditMode {
					// 편집 모드 - 전체 선택 버튼
					VStack {
						Button {
							viewStore.send(.toggleSelectAllItem)
						} label: {
							let isAllSelected = viewStore.mailList.allSatisfy { $0.isSelect }
							if isAllSelected {
								Image.init(systemName: "checkmark.circle.fill")
									.renderingMode(.template)
									.foregroundStyle(Color.blue)
							} else {
								Image.init(systemName: "circle")
									.tint(.primary)
							}
							Text("전체")
								.tint(.primary)
							Spacer()
						}
						.padding()
					}
					.background(Color.background)
				} else {
					// 일반 모드 - 검색 바
					VStack {
						let searchStore = store.scope(state: \.searchState, action: \.searchAction)
						if !viewStore.isSearchFieldOpen {
							// 홈 UI
							SearchField(searchText: .constant(searchStore.viewState.text), isFilterEnabled: true)
								.frame(height: 64)
								.padding(.horizontal)
								.disabled(true)
								.onTapGesture {
									viewStore.send(.toggleSearchFieldExpand)
								}
						} else {
							// 검색 UI
							SearchView(store: searchStore)
								.background(Color.background)
								.frame(height: proxy.size.height + 88)
								.offset(y: -72)
						}
					}
					.offset(y: calcSearchViewHeight - 64)
					.opacity(calcSearchViewHeight / 64)
				}
				Spacer()
			}
		}
	}
	
	private func contextMenuView(_ store: Store<ContextMenuReducer.State, ContextMenuReducer.Action>) -> some View {
		ZStack {
			if store.viewState.show {
				Color.black.opacity(0.001)
					.ignoresSafeArea()
					.simultaneousGesture(
						TapGesture()
							.onEnded {
								store.send(.viewAction(.showToggle))
							}
					)
					.simultaneousGesture(
						DragGesture()
							.onChanged { _ in
								store.send(.viewAction(.showToggle))
							}
					)
//					.gesture(
//						SimultaneousGesture(
//							TapGesture()
//								.onEnded {
//									store.send(.viewAction(.showToggle))
//								},
//							DragGesture()
//								.onChanged { _ in
//									store.send(.viewAction(.showToggle))
//								}
//						)
//					)
			}
			
			ContextMenu(store: store) {
				Button {
					print("컨텍스트 메뉴 - 이동")
				} label: {
					HStack {
						Text("이동")
						Spacer()
					}
					.frame(maxWidth: .infinity)
					.contentShape(Rectangle())
				}
				Button {
					print("컨텍스트 메뉴 - 복사")
				} label: {
					HStack {
						Text("복사")
						Spacer()
					}
					.frame(maxWidth: .infinity)
					.contentShape(Rectangle())
				}
				Button {
					print("컨텍스트 메뉴 - 스팸/해킹 신고")
				} label: {
					HStack {
						Text("스팸/해킹 신고")
						Spacer()
					}
					.frame(maxWidth: .infinity)
					.contentShape(Rectangle())
				}
			}
		}
	}
	
	private func drawerMenu(_ viewStore: ViewStore<MailReducer.State.ViewState, MailReducer.Action.ViewAction>) -> some View {
		VStack {
			if viewStore.isDrawerMenuOpen {
				ZStack {
					Color.gray.opacity(0.8)
						.ignoresSafeArea()
						.onTapGesture {
							viewStore.send(.toggleDrawerMenu, animation: .easeInOut)
						}
					
					HStack(spacing: 0) {
						DrawerMenu(
                            isDrawerMenuOpen: Binding(
                                get: { viewStore.isDrawerMenuOpen },
                                set: { _ in viewStore.send(.toggleDrawerMenu) }
                            ),
							menuBoxes: [
								.init(icon: Image(systemName: "envelope"), name: "전체 메일함", count: 11),
								.init(icon: Image(systemName: "tray"), name: "받은 메일함", count: 999),
								.init(icon: Image(systemName: "envelope.front"), name: "보낸 메일함", count: 6),
								.init(icon: Image(systemName: "square.and.pencil"), name: "임시 보관함", count: 1),
								.init(icon: Image(systemName: "archivebox"), name: "보관 메일함", count: 90),
								.init(icon: Image(systemName: "xmark.bin.fill"), name: "스팸 메일함", count: 90),
								.init(icon: Image(systemName: "trash"), name: "휴지통", count: 90, trailingAction: ("비우기", {}))
							],
							menuFolders: []
                        )
                        .frame(width: 280)
						.background(Color.background)
                        .transition(.move(edge: .leading))
						
						Spacer()
					}
				}
			}
		}
	}
}

#Preview {
	Mail_Preview()
}

struct Mail_Preview: View {
	var body: some View {
		let store = Store(initialState: MailReducer.State(), reducer: { MailReducer() })
		MailView(store: store)
	}
}
