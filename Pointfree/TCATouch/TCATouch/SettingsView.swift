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
				Toggle("Haptic feedback", isOn: viewStore.$isHapticFeedbackEnabled)
				TextField("Display name", text: viewStore.$displayName)
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
		@BindingState var protectMyPosts = false
		@BindingState var enableNotifications = false
		@BindingState var sendEmailNotifications = false
		@BindingState var sendMobileNotifications = false
	}
	enum Digest { case daily, weekly, monthly, yearly }

	enum Action: BindableAction {
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		
		Reduce { state, action in
			switch action {
			case .binding(\.$displayName):
				// Validate display name
				return .none
			case .binding(\.$enableNotifications):
				// Return an authorization request effect
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
