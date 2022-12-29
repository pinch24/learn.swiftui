//
//  NotificationViewModel.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/12/29.
//

import SwiftUI
import UserNotifications
import FirebaseMessaging

class NotificationViewModel: ObservableObject {
	@Published var permission: UNAuthorizationStatus?
	@AppStorage("subscribedToAllNotifications") var subscribedtoAllNotification: Bool = false
	
	func getNotificationsSettings() {
		UNUserNotificationCenter.current().getNotificationSettings { permission in
			DispatchQueue.main.async {
				self.permission = permission.authorizationStatus
			}
			
			if permission.authorizationStatus == .authorized {
				DispatchQueue.main.async {
					UIApplication.shared.registerForRemoteNotifications()
				}
				
				if self.subscribedtoAllNotification {
					self.subscribedAllTopics()
				}
				else {
					self.unsubscribeFromAllTopics()
				}
			}
			else {
				DispatchQueue.main.async {
					UIApplication.shared.unregisterForRemoteNotifications()
					UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
				}
				self.unsubscribeFromAllTopics()
			}
		}
	}
	
	private func subscribedAllTopics() {
		guard permission == .authorized else { return }
		
		Messaging.messaging().subscribe(toTopic: "all") { error in
			if let error = error {
				print("Error while subscribing: ", error)
				return
			}
			print("Subscribed to notifications for all topics")
		}
	}
	
	private func unsubscribeFromAllTopics() {
		Messaging.messaging().unsubscribe(fromTopic: "all") { error in
			if let error = error {
				print("Error while unsubscribing: ", error)
			}
			print("Unsubscribed from notifications for all topics")
		}
	}
}
