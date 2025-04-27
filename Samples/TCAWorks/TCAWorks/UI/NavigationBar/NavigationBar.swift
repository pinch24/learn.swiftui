//
//  NavigationBar.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import SwiftUI

public struct NavigationBar: View {
	@Environment(\.dismiss) var dismiss
	
	public enum NavigationBarType { case menu, back, close, search }
	
	var title: String
	var type: NavigationBarType
	var rightItems: [NavigationBarItem] = []
	
	var onMenu: (() -> Void)?
	var onBack: (() -> Void)?
	
	public init(title: String, type: NavigationBarType = .menu, rightItems: [NavigationBarItem] = [], onMenu: ( () -> Void)? = nil, onBack: ( () -> Void)? = nil) {
		self.title = title
		self.type = type
		self.rightItems = rightItems
		self.onMenu = onMenu
		self.onBack = onBack
	}
	
	public var body: some View {
		HStack {
			// Left Item
			switch type {
			case .menu:
				Button {
					onMenu?()
				} label: {
					Image(systemName: "line.3.horizontal")
						.foregroundStyle(Color.primary)
				}
				
			case .back:
				Button {
					onBack?()
				} label: {
					Image(systemName: "chevron.left")
						.foregroundStyle(Color.primary)
				}
				
			case .close:
				Button {
					dismiss()
				} label: {
					Image(systemName: "xmark")
						.foregroundStyle(Color.primary)
				}
				
			case .search:
				Button {
					dismiss()
				} label: {
					Image(systemName: "magnifyingglass")
						.foregroundStyle(Color.primary)
				}
			}
			
			// Title
			Text(title)
				.font(.title2)
				.foregroundStyle(Color.primary)
			
			Spacer()
			
			// Right Item
			HStack(spacing: 16) {
				ForEach(rightItems) { item in
					Button(action: item.action) {
						item.iconView
							.tint(Color.primary)
					}
				}
			}
		}
		.padding(16)
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

public struct NavigationBarItem: Identifiable {
	public let id = UUID()
	let iconView: AnyView
	let action: () -> Void
	
	public init(iconView: AnyView, action: (() -> Void)? = nil) {
		self.iconView = iconView
		self.action = action ?? {}
	}
}

#Preview {
	NavigationBarPreview()
}

private struct NavigationBarPreview: View {
	@State private var path = NavigationPath()
	@State private var isDrawerMenuOpen = false
	
	private enum Route: Hashable {
		case detail
		case modal
		case search
	}
	
	var body: some View {
		ZStack {
			NavigationStack(path: $path) {
				NavigationBar(title: "타이틀", type: .menu, rightItems: [
					NavigationBarItem(iconView: AnyView(
						Menu {
							Button("월간", action: {})
							Button("주간", action: {})
							Button("일간", action: {})
						} label: {
							HStack(spacing: 0) {
								Text("주간")
									.font(.caption)
								Image(systemName: "arrowtriangle.down.fill")
									.scaleEffect(0.6)
							}
							.frame(width: 53, height: 30)
							.foregroundColor(Color.primary)
							.background(
								RoundedRectangle(cornerRadius: 20)
									.stroke(Color.secondary)
							)
						}
					), action: {}),
					NavigationBarItem(iconView: AnyView(Image(systemName: "trash"))) {},
					NavigationBarItem(iconView: AnyView(Image(systemName: "archivebox"))) {},
					NavigationBarItem(iconView: AnyView(Image(systemName: "mail"))) {},
					NavigationBarItem(
						iconView: AnyView(
							ContextMenu1 {
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
							} label: {
								Image(systemName: "ellipsis")
									.rotationEffect(.degrees(90))
							}
						)
					)
				], onMenu: {
					withAnimation {
						isDrawerMenuOpen = true
					}
				})
				.overlay(
					Rectangle()
						.frame(height: 1)
						.foregroundColor(Color.secondary),
					alignment: .bottom
				)
				.navigationDestination(for: Route.self) { route in
					if route == .detail {
						DetailView()
					} else if route == .modal {
						ModalView()
					} else if route == .search {
						SearchView()
					}
				}
				
				Spacer()
				
				Button {
					path.append(Route.detail)
				} label: {
					VStack {
						Image(systemName: "book.pages")
							.resizable()
							.frame(width: 22, height: 22)
						Text("상세 화면")
					}
					.font(.headline)
					.tint(.primary)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 16)
							.stroke(Color.secondary, lineWidth: 2)
							.background(Color.white.cornerRadius(16))
					)
				}
				Spacer()
			}
			
			if isDrawerMenuOpen {
				Color.black.opacity(0.2)
					.ignoresSafeArea()
					.onTapGesture {
						withAnimation {
							isDrawerMenuOpen = false
						}
					}
				
				HStack(spacing: 0) {
					DrawerMenu(path: $path, isDrawerMenuOpen: $isDrawerMenuOpen)
						.frame(width: 280)
						.background(Color.white)
						.transition(.move(edge: .leading))
					
					Spacer()
				}
			}
		}
	}
	
	private struct DrawerMenu: View {
		@Binding var path: NavigationPath
		@Binding var isDrawerMenuOpen: Bool
		
		var body: some View {
			VStack(alignment: .leading, spacing: 16) {
				Text("메뉴")
					.font(.title)
					.padding()
				Divider()
					.padding(.bottom, 16)
				
				Button {
					path.append("Modal")
					isDrawerMenuOpen = false
				} label: {
					Label {
						Text("모달")
					} icon: {
						Image(systemName: "arrow.up.forward.app")
					}
					.tint(Color.primary)
				}
				
				Button {
					path.append("Search")
					isDrawerMenuOpen = false
				} label: {
					Label {
						Text("검색")
					} icon: {
						Image(systemName: "magnifyingglass")
					}
					.tint(Color.primary)
				}
				
				Spacer()
			}
			.padding()
		}
	}
	
	private struct DetailView: View {
		@Environment(\.dismiss) var dismiss
		@State private var isFavorite = false
		@State private var isToggle = false

		var body: some View {
			VStack {
				NavigationBar(title: "상세 화면",
					   type: .back,
					   rightItems: [
						NavigationBarItem(iconView: AnyView(
							Button {
								isFavorite.toggle()
							} label: {
								Image(systemName: isFavorite ? "star.fill" : "star")
									.tint(.yellow)
							}
							
						)) {},
						NavigationBarItem(iconView: AnyView(
							HStack(spacing: -16) {
								Text("참석여부")
									.frame(width: 64)
									.font(.subheadline)
									.lineLimit(1)
								Toggle("참석여부", isOn: $isToggle)
									.scaleEffect(0.5)
									.labelsHidden()
							}
						)) {},
						NavigationBarItem(iconView: AnyView(
							Text("저장")
								.frame(width: 28)
								.font(.subheadline)
								.foregroundColor(.white)
								.padding(.horizontal, 12)
								.padding(.vertical, 6)
								.background(
									RoundedRectangle(cornerRadius: 18)
										.fill(Color.black.opacity(0.8))
								)
						)) {},
					   ],
					   onBack: { dismiss() }
				)
				.overlay(
					Rectangle()
						.frame(height: 1)
						.foregroundColor(.gray.opacity(0.4)),
					alignment: .bottom
				)

				Spacer()
				Text("DETAIL VIEW")
				Spacer()
			}
			.navigationBarBackButtonHidden(true)
		}
	}
	
	private struct ModalView: View {
		@Environment(\.dismiss) var dismiss
		
		var body: some View {
			VStack {
				NavigationBar(title: "모달 화면", type: .close, onBack: { dismiss() })
					.overlay(
						Rectangle()
							.frame(height: 1)
							.foregroundColor(.gray.opacity(0.4)),
						alignment: .bottom
					)
				
				Spacer()
				Text("모달 컨텐츠")
				Spacer()
			}
			.navigationBarBackButtonHidden(true)
		}
	}
	
	private struct SearchView: View {
		@Environment(\.dismiss) var dismiss
		
		var body: some View {
			VStack {
				NavigationBar(title: "검색", type: .search, rightItems: [
					NavigationBarItem(iconView: AnyView(Image(systemName: "slider.horizontal.3"))) {},
				])
				.overlay(
					Rectangle()
						.frame(height: 1)
						.foregroundColor(.gray.opacity(0.4)),
					alignment: .bottom
				)
				
				Spacer()
				Text("모달 컨텐츠")
				Spacer()
			}
			.navigationBarBackButtonHidden(true)
		}
	}
}
