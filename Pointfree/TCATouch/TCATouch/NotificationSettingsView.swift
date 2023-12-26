//
//  NotificationSettingsView.swift
//  TCATouch
//
//  Created by mk on 12/26/23.
//

import SwiftUI
import ComposableArchitecture

struct NotificationSettingsView: View {
	let store: StoreOf<Settings>
	
	struct ViewState: Equatable {
		@BindingViewState var enableNotifications: Bool
		@BindingViewState var sendEmailNotifications: Bool
		@BindingViewState var sendMobileNotifications: Bool
		
		init(bindingViewStore: BindingViewStore<Settings.State>) {
			self._enableNotifications = bindingViewStore.$enableNotifications
			self._sendEmailNotifications = bindingViewStore.$sendEmailNotifications
			self._sendMobileNotifications = bindingViewStore.$sendMobileNotifications
		}
	}
	
    var body: some View {
		WithViewStore(self.store, observe: ViewState.init) { viewStore in
			Form {
				Toggle("Enable notification", isOn: viewStore.$enableNotifications)
			}
		}
    }
}

#Preview {
	NotificationSettingsView(store: Store(initialState: Settings.State(), reducer: {
		Settings()
	}))
}
