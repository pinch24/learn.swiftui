//
//  ContextMenu.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI
import ComposableArchitecture

public struct ContextMenu: View {
	let store: StoreOf<ContextMenuReducer>
	private let actions: () -> AnyView
	
	public init(store: StoreOf<ContextMenuReducer>, @ViewBuilder actions: @escaping () -> some View) {
		self.store = store
		self.actions = { AnyView(actions()) }
	}
	
	public var body: some View {
		WithViewStore(
			store.scope(
				state: \.viewState,
				action: \.viewAction),
			observe: { $0 },
			content: { viewStore in
				if viewStore.show {
					VStack(alignment: .leading, spacing: 8) {
						actions()
					}
					.padding()
					.frame(width: 144)
					.background(
						RoundedRectangle(cornerRadius: 16)
							.stroke(Color.secondary, lineWidth: 1)
							.background(Color.white.cornerRadius(16))
					)
					.tint(Color.primary)
					.transition(.opacity)
					.modifier(PositionModifier(frame: viewStore.frame))
				}
			}
		)
	}
	
	// @Binding frame으로 ContextMenu가 표시될 위치를 지정
	static func geometryReader(action: @escaping (CGRect) -> Void) -> some View {
		GeometryReader { proxy in
			Color.clear
				.onAppear {
					let frame = proxy.frame(in: .global)
					action(frame)
				}
//				.onChange(of: proxy.frame(in: .global)) { old, new in
//					action(new)
//				}
		}
	}
	
	// @Binding frame이 없으면 현재 위치의 오프셋으로, 있으면 frame에 설정된 위치에 표시
	private struct PositionModifier: ViewModifier {
		let frame: CGRect
		func body(content: Content) -> some View {
			if frame == .zero {
				content.offset(x: -72, y: 72)
			} else {
				content.position(x: frame.minX - 54, y: frame.maxY)
			}
		}
	}
}

#Preview {
	ContextMenuPreview1()
	ContextMenuPreview2()
}

struct ContextMenuPreview1: View {
	let store = Store(
		initialState: ContextMenuReducer.State(),
		reducer: { ContextMenuReducer() }
	)
	
	var body: some View {
		WithViewStore(
			store.scope(
				state: \.viewState,
				action: \.viewAction),
			observe: { $0 },
			content: { viewStore in
				ZStack {
					VStack {
						NavigationBar(title: "Navigation Bar", type: .menu, rightItems: [
							NavigationBarItem(iconView: AnyView(
								Button {
									viewStore.send(.showToggle)
								} label: {
									Image(systemName: "ellipsis")
										.rotationEffect(.degrees(90))
								}.overlay(ContextMenu.geometryReader { frame in
									viewStore.send(.setFrame(frame))
								})
							))
						])
						
						Divider()
						
						Spacer()
					}
					
					// 컨텍스트 메뉴
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
				.background(Color.background)
			}
		)
	}
}

struct ContextMenuPreview2: View {
	let store = Store(
		initialState: ContextMenuReducer.State(),
		reducer: { ContextMenuReducer() }
	)
	
	var body: some View {
		WithViewStore(
			store.scope(
				state: \.viewState,
				action: \.viewAction),
			observe: { $0 },
			content: { viewStore in
				ScrollView {
					ForEach(0..<10) { item in
						Text("\(item)")
					}
					
					HStack {
						Spacer()
						
						Button {
							viewStore.send(.showToggle)
						} label: {
							Image(systemName: "ellipsis")
								.rotationEffect(.degrees(90))
								.tint(.primary)
						}
						.overlay(
							// 컨텍스트 메뉴
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
						)
					}
					.padding()
					.background(Color.secondary.opacity(0.4))
					
					ForEach(0..<10) { item in
						Text("\(item)")
					}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.secondary.opacity(0.2))
			}
		)
	}
}
