//
//  MailList.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import SwiftUI
import ComposableArchitecture

struct MailList: View {
	private let viewStore: ViewStore<MailReducer.State.ViewState, MailReducer.Action.ViewAction>
	init(viewStore: ViewStore<MailReducer.State.ViewState, MailReducer.Action.ViewAction>) {
		self.viewStore = viewStore
	}
	
	var body: some View {
		List {
			// 앱바, 검색필드 영역 패딩
			Color.clear.frame(height: 108)
			
			// 메일 리스트
			ForEach(viewStore.mailList) { item in
				MailItemView(mail: item,
							 isEditMode: viewStore.isEditMode,
							 onToggleFavorite: { viewStore.send(.toggleFavoriteItem(id: item.id)) },
							 onToggleSelect: { viewStore.send(.toggleSelectItem(id: item.id)) }
				)
				.listRowSeparator(.hidden)
				.listRowBackground(Color.clear)
				.listRowInsets(.init())
			}
		}
		.listStyle(.plain)
	}
	
	private struct MailItemView: View {
		var mail: MailItem
		var isEditMode: Bool = false
		var onToggleFavorite: (() -> Void)?
		var onToggleSelect: (() -> Void)?
		
		var body: some View {
			ZStack {
				VStack(alignment: .leading, spacing: 4) {
					HStack {
						if isEditMode {
							// 편집 모드 체크박스
							if mail.isSelect {
								Image.init(systemName: "checkmark.circle.fill")
									.renderingMode(.template)
									.foregroundStyle(Color.blue)
							} else {
								Image.init(systemName: "circle")
							}
						} else {
							// 읽지 않은 메일 표시
							Circle()
								.fill(mail.isRead ? .clear : Color.accentColor)
								.frame(width: 8, height: 8)
						}
						
						Text(mail.sender)
							.lineLimit(1)
						
						Spacer()
						
						boxView(mail.mailBox)
						
						Text(mail.time)
							.foregroundColor(Color.secondary)
					}
					
					HStack {
						VStack(alignment: .leading) {
							HStack(spacing: 2) {
								// 메일 리플
								Group {
									switch mail.mailReply {
										case .none:
											Rectangle()
												.foregroundStyle(.clear)
										case .reply:
											Image(systemName: "arrowshape.turn.up.backward.fill")
												.foregroundStyle(.gray)
												.scaleEffect(0.5)
										case .forward:
											Image(systemName: "arrowshape.turn.up.forward.fill")
												.foregroundStyle(.gray)
												.scaleEffect(0.5)
									}
								}
								.frame(width: 12, height: 12)
								
								// 메일 타이틀 태그
								if let tags = mail.titleTags, tags.isEmpty == false {
									ForEach(tags, id: \.self) { tag in
										tagView(tag)
									}
								}
								
								Text(mail.title)
									.foregroundColor(Color.primary)
									.lineLimit(1)
							}
							
							HStack {
								Rectangle()
									.foregroundStyle(.clear)
									.frame(width: 12, height: 12)
								Text(mail.content)
									.foregroundColor(Color.primary)
									.lineLimit(1)
							}
						}
						
						Spacer()
						
						Image(systemName: "star.fill")
							.foregroundStyle(mail.isFavorite ? .yellow : .gray)
							.onTapGesture {
								onToggleFavorite?()
							}
					}
				}
				.padding(.horizontal, 16)
				.padding(.vertical, 12)
				.background(Color.background)
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
					Button {
						// ...
					} label: {
						Image(systemName: "trash")
					}
					.tint(Color.gray)
					
					Button {
						// ...
					} label: {
						Image(systemName: "archivebox")
					}
					.tint(Color.blue)
				}
				.disabled(isEditMode)
				
				if isEditMode {
					// .clear 컬러에는 탭이 동작하지 않아서 투명도를 0.01로 지정
					Color.background.opacity(0.01)
						.onTapGesture {
							onToggleSelect?()
						}
				}
			}
		}
		
		private func boxView(_ box: MailItem.MailBox) -> some View {
			var boxName = ""
			switch box {
				case .inbox:
					boxName = "받은 메일함"
				case .sent:
					boxName = "보낸 메일함"
				default:
					break
			}
			
			guard boxName.isEmpty == false else { return AnyView(EmptyView()) }
			
			return AnyView(
				Text(boxName)
					.foregroundColor(Color.gray)
					.padding(.horizontal, 4)
					.padding(.vertical, 2)
					.background(Color.background)
					.border(Color.gray, width: 1)
					.cornerRadius(3)
			)
		}
		
		private func tagView(_ tag: String) -> some View {
			if tag == "#승인대기" {
				return AnyView(
					Text(tag.dropFirst())
						.foregroundColor(Color.background)
						.padding(.horizontal, 5)
						.padding(.vertical, 2)
						.background(Color.gray)
						.cornerRadius(4)
				)
			} else if tag == "#일정" {
				return AnyView(
					Image(systemName: "calendar")
						.foregroundStyle(Color.blue)
						.scaleEffect(0.8)
				)
			} else if tag == "#중요" {
				return AnyView(
					Image(systemName: "exclamationmark.circle.fill")
						.foregroundStyle(Color.red)
						.scaleEffect(0.8)
				)
			} else if tag.hasPrefix("#") {
				return AnyView(
					Text(tag.dropFirst())
						.foregroundColor(Color.white)
						.padding(.horizontal, 5)
						.padding(.vertical, 2)
						.background(Color.red)
						.cornerRadius(4)
				)
			} else {
				return AnyView(
					Text(tag)
						.foregroundColor(Color.red)
				)
			}
		}
	}
}

#Preview {
	MailList_Preview()
}

struct MailList_Preview: View {
	var body: some View {
		let store = Store(initialState: MailReducer.State(), reducer: { MailReducer() })
		WithViewStore(
			store.scope(
				state: \.viewState,
				action: \.viewAction
			),
			observe: { $0 }
		) { viewStore in
			MailList(viewStore: viewStore)
		}
	}
}
