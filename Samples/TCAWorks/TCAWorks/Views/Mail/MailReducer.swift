//
//  MailReducer.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct MailReducer {
	@ObservableState
	public struct State: Equatable, Sendable {
		public struct ViewState: Equatable, Sendable {
			public var title: String = "Hello, Mail Home!"
			public var isDrawerMenuOpen = false
			public var isSearchFieldOpen = false
			public var isEditMode = false
			public var mailList: [MailItem] = mockData
		}

		public init() {}

		public var viewState: ViewState = ViewState()
		public var searchState: SearchFieldReducer.State = .init(isNeedFilter: true)
	}

	public enum Action: Equatable {
		case viewAction(ViewAction)
		case innerAction(InnerAction)
		case searchAction(SearchFieldReducer.Action)

		public enum ViewAction: Equatable {
			case buttonTapped
			case toggleDrawerMenu
			case toggleSearchFieldExpand
			case toggleEditMode
			case toggleFavoriteItem(id: UUID)
			case toggleSelectItem(id: UUID)
			case toggleSelectAllItem
		}

		public enum InnerAction: Equatable {
			case setTitle(String)
		}
	}
	
	public init() {}
	
	public var body: some ReducerOf<Self> {
		Scope(state: \.searchState, action: \.searchAction) {
			SearchFieldReducer()
		}
		
		Reduce { state, action in
			switch action {
				case .viewAction(let viewAction):
					switch viewAction {
						case .buttonTapped:
							break
						case .toggleDrawerMenu:
							state.viewState.isDrawerMenuOpen.toggle()
						case .toggleSearchFieldExpand:
							state.viewState.isSearchFieldOpen.toggle()
						case .toggleEditMode:
							state.viewState.isEditMode.toggle()
						case .toggleFavoriteItem(let id):
							if let index = state.viewState.mailList.firstIndex(where: { $0.id == id }) {
								state.viewState.mailList[index].isFavorite.toggle()
							}
						case .toggleSelectItem(let id):
							if let index = state.viewState.mailList.firstIndex(where: { $0.id == id }) {
								state.viewState.mailList[index].isSelect.toggle()
							}
						case .toggleSelectAllItem:
							let isAllSelected = state.viewState.mailList.allSatisfy { $0.isSelect }
							state.viewState.mailList = state.viewState.mailList.map {
								var item = $0
								item.isSelect = !isAllSelected
								return item
							}
					}
					return reduceViewAction(viewAction, state: &state)
					
				case .innerAction(let innerAction):
					return reduceInnerAction(innerAction, state: &state)
					
				case .searchAction(let searchAction):
					switch searchAction {
						case .viewAction(.dismiss):
							state.viewState.isSearchFieldOpen.toggle()
						default:
							break
					}
					return reduceSearchAction(searchAction, state: &state)
			}
		}
	}
}

// MARK: - Actions
extension MailReducer {
	func reduceViewAction(_ viewAction: Action.ViewAction, state: inout State) -> Effect<Action> {
		switch viewAction {
			case .buttonTapped:
				return .run { send in
					await send(.innerAction(.setTitle(UUID().uuidString)))
				}
			default:
				return .none
		}
	}

	func reduceInnerAction(_ innerAction: Action.InnerAction, state: inout State) -> Effect<Action> {
		switch innerAction {
			case .setTitle(let title):
				state.viewState.title = title
				return .none
		}
	}
	
	func reduceSearchAction(_ searchAction: SearchFieldReducer.Action, state: inout State) -> Effect<Action> {
		switch searchAction {
			default:
				return .none
		}
	}
}

// MARK: - Types
public struct MailItem: Identifiable, Equatable, Sendable {
	public let id: UUID = UUID()
	public let sender: String
	public let senderTag: String?
	public let title: String
	public let titleTags: [String]?
	public let content: String
	public let mailBox: MailBox
	public let mailReply: MailReply
	public let time: String
	public let isRead: Bool
	public var isFavorite: Bool
	public var isSelect: Bool
	public var files: [String]?
	
	public enum MailBox: Sendable {
		case inbox
		case sent
		case drafts
		case trash
	}
	
	public enum MailReply: Sendable {
		case none
		case reply
		case forward
	}
	
	public init(
		sender: String,
		senderTag: String? = nil,
		title: String,
		titleTags: [String]? = nil,
		content: String,
		mailBox: MailBox = .inbox,
		mailReply: MailReply = .none,
		time: String,
		isRead: Bool,
		isFavorite: Bool,
		isSelect: Bool = false,
		files: [String]? = nil
	) {
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

// MARK: - Tests
extension MailReducer {
	private static let mockData: [MailItem] = [
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
}
