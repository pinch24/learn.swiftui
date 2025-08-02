//
//  ContextMenu.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI
import ComposableArchitecture

public struct ContextMenu: View {
	private struct Constants {
		static let width = CGFloat(144)
		static let spacing = CGFloat(8)
		static let padding = CGFloat(16)
		static let cornerRadius = CGFloat(16)
		static let strokeWidth = CGFloat(1)
		static let dispOffset = CGFloat(72)
		static let dispPositon = CGFloat(54)
		// 팝업 메뉴와 메뉴 표시 버튼의 간격은 menuItemHeight 변경으로 설정
		static let menuItemHeight = CGFloat(34)
	}
	
	@Binding var show: Bool
	@State private var size: CGSize = .zero
	// TODO: frame 프로퍼티는 머지 후 삭제 예정
	private var frame: CGRect
	private var position: CGPoint
	private let menuView: () -> AnyView
	
	public init(
		show: Binding<Bool>,
		frame: CGRect = .zero,
		position: CGPoint = .zero,
		@ViewBuilder menuView: @escaping () -> some View
	) {
		self._show = show
		self.frame = frame
		self.position = position
		self.menuView = { AnyView(menuView()) }
	}
	
	public var body: some View {
		Group {
			if show {
				ZStack {
					DismissBackground(show: $show)
					VStack(alignment: .leading, spacing: Constants.spacing) {
						menuView()
					}
					.modifier(PopupMenuStyle())
					.modifier(SetPopupSize(size: $size))
					.modifier(PopupMenuPosition(position: position, size: size))
				}
			}
		}
	}
	
	// 컨텍스트 메뉴 백그라운드 (배경화면 터치/스크롤로 메뉴 닫기)
	private struct DismissBackground: View {
		@Binding var show: Bool
		var body: some View {
			// NOTE: 터치 동작이 가능하도록 투명도를 0.001로 지정
			Color.black.opacity(0.001)
				.ignoresSafeArea()
				.simultaneousGesture(
					TapGesture()
						.onEnded {
							show.toggle()
						}
				)
				.simultaneousGesture(
					DragGesture()
						.onChanged { _ in
							show.toggle()
						}
				)
		}
	}
	
	// 팝업 메뉴 스타일
	private struct PopupMenuStyle: ViewModifier {
		func body(content: Content) -> some View {
			content
				.padding(Constants.padding)
				.frame(width: ContextMenu.Constants.width)
				.background(
					RoundedRectangle(cornerRadius: ContextMenu.Constants.cornerRadius)
						.stroke(Color.secondary.opacity(0.3), lineWidth: ContextMenu.Constants.strokeWidth)
						.background(Color.white.cornerRadius(ContextMenu.Constants.cornerRadius))
				)
				.tint(Color.primary)
				.transition(.opacity)
		}
	}
	
	// TODO: 머지 후 삭제 예정
	public static func setFrame(_ binding: Binding<CGRect>) -> some View {
		GeometryReader { proxy in
			Color.clear
				.onAppear {
					binding.wrappedValue = proxy.frame(in: .global)
				}
		}
	}
	
	// 팝업 메뉴 위치 지정
	// position 값이 없으면 현재 위치의 오프셋으로, position 값이 있으면 설정된 위치에 표시
	private struct PopupMenuPosition: ViewModifier {
		let position: CGPoint
		let size: CGSize
		func body(content: Content) -> some View {
			if position == .zero {
				content.offset(x: -Constants.dispOffset, y: Constants.dispOffset)
			} else {
				let x: CGFloat = {
					let baseOffset = position.x < Constants.width
						? Constants.dispPositon
						: -Constants.dispPositon
					let paddingOffset = (position.x < Constants.width && position.x < Constants.padding)
						? Constants.padding
						: .zero
					return position.x + baseOffset + paddingOffset
				}()
				let y = position.y
				+ (size.height / Constants.menuItemHeight * Constants.padding)
				- Constants.padding
				content.position(x: x, y: y)
			}
		}
	}
	
	// 팝업 메뉴 위치 설정(NavigationBar)
	public struct SetPopupPosition: ViewModifier {
		@Binding var position: CGPoint
		public init(_ binding: Binding<CGPoint>) {
			self._position = binding
		}
		
		public func body(content: Content) -> some View {
			content
				.background(
					GeometryReader { proxy in
						Color.clear
							.onAppear {
								position = proxy.frame(in: .global).origin
							}
					}
				)
		}
	}
	
	// 팝업 메뉴 크기 설정(NavigationBar)
	private struct SetPopupSize: ViewModifier {
		@Binding var size: CGSize
		
		func body(content: Content) -> some View {
			content
				.background(
					GeometryReader { proxy in
						Color.clear
							.onAppear {
								size = proxy.size
							}
					}
				)
		}
	}
}

#Preview {
	ContextMenuInNavigationBarPreview()
	ContextMenuPreview()
}

struct ContextMenuInNavigationBarPreview: View {
	@State var show = false
	@State var position = CGPoint.zero
	
	var body: some View {
		ZStack {
			VStack {
				Text("....")
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.safeAreaInset(edge: .top) {
				NavigationBar(title: "앱바", type: .menu, rightItems: [
					NavigationBarItem(iconView: AnyView(
						Button {
							show.toggle()
						} label: {
							Image(systemName: "ellipsis")
						}.modifier(ContextMenu.SetPopupPosition($position))
					))
				])
			}
			
			ContextMenu(show: $show, position: position) {
				VStack {
					Button("이동", action: {
						print("컨텍스트 메뉴 - 이동")
					})
					Button("복사", action: {
						print("컨텍스트 메뉴 - 복사")
					})
					Button("스팸/해킹 신고", action: {
						print("컨텍스트 메뉴 - 스팸/해킹 신고")
					})
					Button("업무로 등록", action: {
						print("컨텍스트 메뉴 - 업무로 등록")
					})
					Button("업무 댓글로 등록", action: {
						print("컨텍스트 메뉴 - 업무 댓글로 등록")
					})
					Button("일정으로 등록", action: {
						print("컨텍스트 메뉴 - 일정으로 등록")
					})
					Button("번역", action: {
						print("컨텍스트 메뉴 - 번역")
					})
				}
			}
		}
		.background(Color.gray.opacity(0.1))
	}
}

struct ContextMenuPreview: View {
	@State var show = false
	var body: some View {
		ScrollView {
			ForEach(0..<10) { item in
				Text("\(item)")
			}
			
			HStack {
				Spacer()
				
				Button {
					show.toggle()
				} label: {
					Image(systemName: "ellipsis")
				}
				.overlay(
					ContextMenu(show: $show) {
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
						Divider()
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
			.background(Color.white)
			
			ForEach(0..<10) { item in
				Text("\(item)")
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.gray.opacity(0.1))
	}
}
