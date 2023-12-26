//
//  SettingsView.swift
//  TCATouch
//
//  Created by mk on 12/26/23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Settings View
struct SettingsView: View {
	let store: StoreOf<Settings>
	
    var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			Form {
				Toggle("Haptic feedback", isOn: viewStore.binding(get: \.isHapticFeedbackEnabled, send: { .isHapticFeedbackEnabledChanged($0) }))
			}
		}
    }
}

#Preview {
	SettingsView(store: Store(initialState: Settings.State(), reducer: {
		Settings()
	}))
}

// MARK: - Settings Reducer
@Reducer
struct Settings: Reducer {
	struct State: Equatable {
		var isLoading = false
		@BindingState var isHapticFeedbackEnabled = true
		@BindingState var digest = Digest.daily
		@BindingState var displayName = ""
		@BindingState var enableNotifications = false
		@BindingState var protectMyPosts = false
		@BindingState var sendEmailNotifications = false
		@BindingState var sendMobileNotifications = false
	}
	enum Digest { case daily, weekly, monthly, yearly }

	enum Action {
		case isHapticFeedbackEnabledChanged(Bool)
		case digestChanged(Digest)
		case displayNameChanged(String)
		case enableNotificationsChanged(Bool)
		case protecteMyPostsChanged(Bool)
		case sendEmailNotificationsChnaged(Bool)
		case sendMobileNotificationsChanged(Bool)
	}
	
	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		switch action {
		case let .isHapticFeedbackEnabledChanged(isEnabled):
			state.isHapticFeedbackEnabled = isEnabled
			return .none
		case let .digestChanged(digest):
			state.digest = digest
			return .none
		case let .displayNameChanged(displayName):
			return .none
		case let .enableNotificationsChanged(isOn):
			return .none
		case let .protecteMyPostsChanged(isOn):
			return .none
		case let .sendEmailNotificationsChnaged(isOn):
			return .none
		case let .sendMobileNotificationsChanged(isOn):
			return .none
		}
	}
}
