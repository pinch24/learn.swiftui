//
//  SideMenuView.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import SwiftUI

//public struct SideMenuView<Content: View, F: Flow>: View where Content: View {
//	private let content: (F) -> Content
//	private let flow: Binding<F?>
//	private let edgeTransition: AnyTransition = .move(edge: .leading)
//	@Binding private var isShowing: Bool
//	
//	public init(
//		flow: Binding<F?>,
//		isShow: Binding<Bool>,
//		content: @escaping (F) -> Content
//	) {
//		self.content = content
//		self.flow = flow
//		self._isShowing = isShow
//	}
//	
//	public var body: some View {
//		ZStack(alignment: .leading) {
//			if isShowing,
//			   let value = flow.wrappedValue {
//				Color.black
//					.opacity(0.3)
//					.ignoresSafeArea()
//					.onTapGesture {
//						isShowing.toggle()
//					}
//				
//				content(value)
//					.frame(maxHeight: .infinity)
//				// TODO: - 디바이스에 따라 노출되는 크기는 다르게 설정 될 수 있음
//					.frame(maxWidth: UIScreen.main.bounds.width * 0.8)
//					.transition(edgeTransition)
//					.background(Color.white)
//			}
//		}
//		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//		.ignoresSafeArea()
//		.animation(.easeInOut(duration: 0.2), value: isShowing)
//	}
//}
//
//public protocol SideMenuPresentable: Identifiable, Hashable {
//	var id: UUID { get }
//}
//
//extension SideMenuPresentable {
//	public func hash(into hasher: inout Hasher) {
//		hasher.combine(id)
//	}
//	
//	public static func == (lhs: Self, rhs: Self) -> Bool {
//		return lhs.id == rhs.id
//	}
//}
