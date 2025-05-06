//
//  MailList.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MailListReducer {
	@ObservableState
	struct State: Equatable, Sendable {
		var mailList: [MailItem]
		var isEditing = false
		var isSelectAll: Bool {
			mailList.allSatisfy { $0.isSelect }
		}
	}

	enum Action: Equatable {
		case toggleEditMode
		case toggleFavoriteItem(id: UUID)
		case toggleSelectItem(id: UUID)
		case toggleSelectAllItem
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .toggleEditMode:
				state.isEditing.toggle()
				return .none
			case .toggleFavoriteItem(let id):
				if let index = state.mailList.firstIndex(where: { $0.id == id }) {
					state.mailList[index].isFavorite.toggle()
				}
				return .none
			case .toggleSelectItem(let id):
				if let index = state.mailList.firstIndex(where: { $0.id == id }) {
					state.mailList[index].isSelect.toggle()
				}
				return .none
			case .toggleSelectAllItem:
				state.mailList = state.mailList.map {
					var item = $0
					item.isSelect = !state.isSelectAll
					return item
				}
				return .none
			}
		}
	}
}

struct MailItem: Identifiable, Equatable, Sendable {
	let id: UUID = UUID()
	let sender: String
	let senderTag: String?
	let title: String
	let titleTags: [String]?
	let content: String
	let mailBox: MailBox
	let mailReply: MailReply
	let time: String
	let isRead: Bool
	var isFavorite: Bool
	var isSelect: Bool
	var files: [String]?
	
	enum MailBox: Sendable {
		case inbox
		case sent
		case drafts
		case trash
	}
	
	enum MailReply: Sendable {
		case none
		case reply
		case forward
	}
	
	init(sender: String, senderTag: String? = nil, title: String, titleTags: [String]? = nil, content: String, mailBox: MailBox = .inbox, mailReply: MailReply = .none, time: String, isRead: Bool, isFavorite: Bool, isSelect: Bool = false, files: [String]? = nil) {
		self.sender = sender
		self.senderTag = senderTag
		self.title = title
		self.titleTags = titleTags
		self.content = content
		self.mailBox = mailBox
		self.mailReply = mailReply
		self.time = time
		self.isRead = isRead
		self.isFavorite = isFavorite
		self.isSelect = isSelect
		self.files = files
	}
}

// MARK: - View
struct MailListView: View {
	let store: StoreOf<MailListReducer>
	let viewStore: ViewStoreOf<MailListReducer>
	
	init(store: StoreOf<MailListReducer>) {
		self.store = store
		self.viewStore = .init(store, observe: \.self)
	}
	
	var body: some View {
		List {
			ForEach(viewStore.mailList) { item in
				MailItemView(mail: item,
							 isEditMode: viewStore.isEditing,
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
		let store = Store(initialState: MailListReducer.State(mailList: mailListMockData), reducer: { MailListReducer() })
		MailListView(store: store)
	}
}

let mailListMockData: [MailItem] = [
	MailItem(
		sender: "김두레",
		title: "[회신요망] 워크샵 일정 공유드립니다.",
		titleTags: ["#승인대기"],
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "11:57",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "손지혜",
		title: "개편내용 총괄 공유드립니다.",
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "11:20",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "김지영",
		title: "RE:앱개발 공통1팀 조직개편 안내",
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .reply,
		time: "09:21",
		isRead: true,
		isFavorite: false
	),
	MailItem(
		sender: "Dooray! Meeting",
		title: "회의실예약알림 14:00~15:00 / 3-1회의실",
		titleTags: ["#일정"],
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .forward,
		time: "12.07",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "김고은(수리) replied to a thread in ...",
		title: "Kim has invited you to edit the file...",
		titleTags: ["#중요", "#보안", "전달금지"],
		content: "짧은 본문인 경우입니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "12.07",
		isRead: false,
		isFavorite: false,
		files: ["디자인실워크샵.pdf", "2025년_워크샵경비.xlsx", "장소.jpg", "풍경.avi"]
	),
	MailItem(
		sender: "조예리",
		title: "택배1건 수령 안내 - 플레이뮤지엄 2층",
		content: "택배1건이 도착하였습니다. 식품이나 부패의 우려가 있는 물품의 경우 가급적 당일 수령을 부탁 드립니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "12.05",
		isRead: true,
		isFavorite: false
	),
	MailItem(
		sender: "김두레",
		title: "[회신요망] 워크샵 일정 공유드립니다.",
		titleTags: ["#승인대기"],
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "11:57",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "손네버",
		title: "개편내용 총괄 공유드립니다.",
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "11:20",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "김카카",
		title: "RE:앱개발 공통1팀 조직개편 안내",
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .reply,
		time: "09:21",
		isRead: true,
		isFavorite: false
	),
	MailItem(
		sender: "Dooray! Meeting",
		title: "회의실예약알림 14:00~15:00 / 3-1회의실",
		titleTags: ["#일정"],
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .forward,
		time: "12.07",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "김네오(위즈) replied to a thread in ...",
		title: "Kim has invited you to edit the file...",
		titleTags: ["#중요", "#보안", "전달금지"],
		content: "짧은 본문인 경우입니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "12.07",
		isRead: false,
		isFavorite: false,
		files: ["디자인실워크샵.pdf", "2025년_워크샵경비.xlsx", "장소.jpg", "풍경.avi"]
	),
	MailItem(
		sender: "조넥슨",
		title: "택배1건 수령 안내 - 플레이뮤지엄 2층",
		content: "택배1건이 도착하였습니다. 식품이나 부패의 우려가 있는 물품의 경우 가급적 당일 수령을 부탁 드립니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "12.05",
		isRead: true,
		isFavorite: false
	),
	MailItem(
		sender: "김원봉(약산)",
		title: "개편내용 총괄 공유드립니다.",
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "11:20",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "여운형(몽양)",
		title: "RE:앱개발 공통1팀 조직개편 안내",
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .reply,
		time: "09:21",
		isRead: true,
		isFavorite: false
	),
	MailItem(
		sender: "Dooray! Meeting",
		title: "회의실예약알림 14:00~15:00 / 3-1회의실",
		titleTags: ["#일정"],
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .forward,
		time: "12.07",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "윤봉길(매헌) replied to a thread in ...",
		title: "Kim has invited you to edit the file...",
		titleTags: ["#중요", "#보안", "전달금지"],
		content: "짧은 본문인 경우입니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "12.07",
		isRead: false,
		isFavorite: false,
		files: ["디자인실워크샵.pdf", "2025년_워크샵경비.xlsx", "장소.jpg", "풍경.avi"]
	),
	MailItem(
		sender: "안중근(도마)",
		title: "택배1건 수령 안내 - 플레이뮤지엄 2층",
		content: "택배1건이 도착하였습니다. 식품이나 부패의 우려가 있는 물품의 경우 가급적 당일 수령을 부탁 드립니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "12.05",
		isRead: true,
		isFavorite: false
	),
	MailItem(
		sender: "손록당",
		title: "[회신요망] 워크샵 일정 공유드립니다.",
		titleTags: ["#승인대기"],
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "11:57",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "무우양",
		title: "개편내용 총괄 공유드립니다.",
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "11:20",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "진청평",
		title: "RE:앱개발 공통1팀 조직개편 안내",
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .reply,
		time: "09:21",
		isRead: true,
		isFavorite: false
	),
	MailItem(
		sender: "Dooray! Meeting",
		title: "회의실예약알림 14:00~15:00 / 3-1회의실",
		titleTags: ["#일정"],
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .forward,
		time: "12.07",
		isRead: false,
		isFavorite: false
	),
	MailItem(
		sender: "양호(홀뢰) replied to a thread in ...",
		title: "Kim has invited you to edit the file...",
		titleTags: ["#중요", "#보안", "전달금지"],
		content: "짧은 본문인 경우입니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "12.07",
		isRead: false,
		isFavorite: false,
		files: ["디자인실워크샵.pdf", "2025년_워크샵경비.xlsx", "장소.jpg", "풍경.avi"]
	),
	MailItem(
		sender: "이서문",
		title: "택배1건 수령 안내 - 플레이뮤지엄 2층",
		content: "택배1건이 도착하였습니다. 식품이나 부패의 우려가 있는 물품의 경우 가급적 당일 수령을 부탁 드립니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "12.05",
		isRead: true,
		isFavorite: false
	),
	MailItem(
		sender: "척계광",
		title: "[회신요망] 워크샵 일정 공유드립니다.",
		titleTags: ["#승인대기"],
		content: "이번에 새로 진행되는 시안화면 먼저 보내드립니다. 의견보내시기를 바랍니다.",
		mailBox: .inbox,
		mailReply: .none,
		time: "11:57",
		isRead: false,
		isFavorite: false
	),
]
