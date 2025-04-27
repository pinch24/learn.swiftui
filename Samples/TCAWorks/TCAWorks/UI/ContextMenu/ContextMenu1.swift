//
//  ContextMenu1.swift
//  TCAWorks
//
//  Created by MK on 4/26/25.
//

import SwiftUI

public struct ContextMenu1<Label: View, Actions: View>: View {
	@State private var isExpanded: Bool = false
	
	private let label: () -> Label
	private let actions: () -> Actions

	public init(@ViewBuilder actions: @escaping () -> Actions, @ViewBuilder label: @escaping () -> Label) {
		self.actions = actions
		self.label = label
	}

	public var body: some View {
		ZStack {
			Button {
				withAnimation {
					isExpanded.toggle()
				}
			} label: {
				label()
					.contentShape(Rectangle())
			}
			.overlay(
				Group {
					if isExpanded {
						VStack(alignment: .leading, spacing: 8) {
							actions()
						}
						.padding()
						.frame(width: 144)
						.background(
							RoundedRectangle(cornerRadius: 16)
								.stroke(.gray, lineWidth: 1)
								.background(Color.white.cornerRadius(16))
						)
						.offset(x: -44, y: 88)
						.transition(.opacity)
						.zIndex(2)
					}
				}
			)
		}
	}
}
#Preview {
	ContextMenu1Preview()
}

struct ContextMenu1Preview: View {
	@State private var isMenuVisible = false
	@State private var buttonFrame: CGRect = .zero
	
	var body: some View {
		ZStack {
			VStack {
				Divider()
				ZStack {
					NavigationBar(title: "타이틀", type: .menu, rightItems: [
						NavigationBarItem(iconView: AnyView(
							Menu {
								Button("월간", action: {
									print("네비게이션바 - 월간")
								})
								Button("주간", action: {
									print("네비게이션바 - 주간")
								})
								Button("일간", action: {
									print("네비게이션바 - 일간")
								})
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
						NavigationBarItem(iconView: AnyView(Image(systemName: "archivebox"))) {},
						NavigationBarItem(iconView: AnyView(Image(systemName: "envelope"))) {},
						NavigationBarItem(
							iconView: AnyView(
								ContextMenu1 {
									Button("이동", action: {
										print("네비게이션바 - 이동")
									})
									Button("복사", action: {
										print("네비게이션바 - 복사")
									})
									Button("스팸/해킹 신고", action: {
										print("네비게이션바 - 스팸/해킹 신고")
									})
								} label: {
									Image(systemName: "ellipsis")
										.rotationEffect(.degrees(90))
								}
							)
						),
						NavigationBarItem(iconView: AnyView(
							Button {
								isMenuVisible.toggle()
							} label: {
								Image(systemName: "ellipsis")
									.rotationEffect(.degrees(90))
							}
								.background(
									GeometryReader { geometry in
										Color.clear
											.onAppear {
												buttonFrame = geometry.frame(in: .global)
											}
											.onChange(of: geometry.frame(in: .global)) { _, newFrame in
												buttonFrame = newFrame
											}
									}
								)
						))
					], onMenu: {
						
					})
				}
				
				Divider()
					.padding(.bottom, 88)
				
				Divider()
				HStack {
					Text("Context Menu")
					Spacer()
					ContextMenu1 {
						Button("이동", action: {
							print("컨텍스트 메뉴 - 이동")
						})
						Button("복사", action: {
							print("컨텍스트 메뉴 - 복사")
						})
						Button("스팸/해킹 신고", action: {
							print("컨텍스트 메뉴 - 스팸/해킹 신고")
						})
					} label: {
						Image(systemName: "ellipsis")
							.rotationEffect(.degrees(90))
					}
					.tint(.primary)

				}
				Divider()
				Spacer()
			}
			.padding()
			
			if isMenuVisible {
				VStack(alignment: .leading, spacing: 8) {
					Button("이동", action: {
						print("ZSTACK - 이동")
					})
					Button("복사", action: {
						print("ZSTACK - 복사")
					})
					Button("스팸/해킹 신고", action: {
						print("ZSTACK - 스팸/해킹 신고")
					})
				}
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 16)
						.stroke(Color.secondary, lineWidth: 1)
						.background(Color.white.cornerRadius(16))
				)
				.position(
					x: buttonFrame.midX - 44,
					y: buttonFrame.maxY + 8
				)
				//.offset(x: 98, y: 72)
				.tint(.primary)
				.transition(.opacity)
			}
		}
	}
}
