//
//  ContextMenuReducer.swift
//  TCAWorks
//
//  Created by MK on 4/27/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct ContextMenuReducer {
	@ObservableState
	public struct State: Equatable {
		public struct ViewState: Equatable, Sendable {
			public var show = false
			public var frame: CGRect = .zero
			// NOTE: isNeedUpdate으로 .setFrame() 액션에 의한 뷰 업데이트를 막음
			// 막지않으면 View 업데이트 -> .overlay() 이벤트 -> .setFrame() 액션 순서로 무한 루프
			public var isNeedUpdate: Bool = false
		}
		
		public var viewState: ViewState = ViewState()
		
		public init(show: Bool = false, frame: CGRect = .zero) {
			self.viewState.show = show
			self.viewState.frame = frame
		}
	}
	
	public enum Action {
		case viewAction(ViewAction)
		
		public enum ViewAction: Equatable {
			case showToggle
			case setFrame(CGRect)
		}
	}
	
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case .viewAction(let viewAction):
					switch viewAction {
						case .showToggle:
							state.viewState.show.toggle()
							state.viewState.isNeedUpdate = true
							return .none
						case .setFrame(let frame):
							if state.viewState.isNeedUpdate {
								state.viewState.isNeedUpdate = false
								state.viewState.frame = frame
							}
							return .none
					}
			}
		}
	}
}

