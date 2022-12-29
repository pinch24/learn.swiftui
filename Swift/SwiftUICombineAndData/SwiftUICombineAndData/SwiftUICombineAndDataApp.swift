//
//  SwiftUICombineAndDataApp.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/04/04.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications

@main
struct SwiftUICombineAndDataApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
	let gcmMessageIDKey = "gcm.message_id"
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		
		Messaging.messaging().delegate = self
		UNUserNotificationCenter.current().delegate = self
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
		application.registerForRemoteNotifications()
		
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		print("application:didRegisterForRemoteNotificationsWithDeviceToken:")
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("application:didFailToRegisterForRemoteNotificationsWithError:")
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		let messageId = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageId)")
		}
		print(userInfo)
		
		completionHandler(UIBackgroundFetchResult.newData)
	}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
		let userInfo = notification.request.content.userInfo
		print(userInfo)
		return [[.banner, .badge, .sound]]
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
		let userInfo = response.notification.request.content.userInfo
		print(userInfo)
	}
}

extension AppDelegate: MessagingDelegate {
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		let deviceToken: [String: String] = ["token": fcmToken ?? ""]
		print("Device Token: ", deviceToken)
	}
}
