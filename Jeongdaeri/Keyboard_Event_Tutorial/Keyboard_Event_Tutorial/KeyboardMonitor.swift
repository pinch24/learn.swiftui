//
//  KeyboardMonitor.swift
//  Keyboard_Event_Tutorial
//
//  Created by mk on 2023/05/07.
//

import Foundation
import UIKit
import Combine

final class KeyboardMonitor : ObservableObject {
	
	enum Status {
		case show, hide
		
		var description : String {
			switch self {
				case .show:
					return "Show!"
				case .hide:
					return "Hide!"
			}
		}
	}
	
	//@Published var updatedKeyboardStatusAction: Status = .hide
	@Published var updatedKeyboardFrameHeight: CGFloat = .zero
	
	lazy var updatedKeyboardStatusAction: AnyPublisher<Status, Never> = $updatedKeyboardFrameHeight.map { (height: CGFloat) -> KeyboardMonitor.Status in
		return height > 0 ? .show : .hide
	}.eraseToAnyPublisher()
	
	var subscriptions = Set<AnyCancellable>()
	
	init() {
		print("KeyboardMonitor - init() called")
		
//		// Keyboard Will Show Notification
//		NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
//			.sink { (noti: Notification) in
//				print("KeyboardMonitor - keyboardWillShowNotification: noti: ", noti)
//				self.updatedKeyboardStatusAction = .show
//			}
//			.store(in: &subscriptions)
//
//		// Keyboard Will Hide Notification
//		NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
//			.sink { (noti: Notification) in
//				print("KeyboardMonitor - keyboardWillHideNotification: noti: ", noti)
//				self.updatedKeyboardStatusAction = .hide
//				self.updatedKeyboardFrameHeight = .zero
//			}
//			.store(in: &subscriptions)
//
//		// Keyboard Did Change Frame Notification
//		NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification)
//			.sink { (noti: Notification) in
//				print("KeyboardMonitor - keyboardWillChangeFrameNotification: noti: ", noti)
//
//				let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//				print("KeyboardMonitor - keyboardWillChangeFrameNotification: keyboardFrame.height: ", keyboardFrame.height)
//				self.updatedKeyboardFrameHeight = keyboardFrame.height
//			}
//			.store(in: &subscriptions)
		
		// Keyboard Will Show Notification to Updated Keyboard Frame Height
		NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
			.merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
			.compactMap { (noti: Notification) -> CGRect in
				return noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
			}
			.map { (keyboardFrame: CGRect) -> CGFloat in
				return keyboardFrame.height
			}
			.subscribe(Subscribers.Assign(object: self, keyPath: \.updatedKeyboardFrameHeight))
		
		// Keyboard Will Hide Notification to Updated Keyboard Frame Height
		NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
			.compactMap { (noti: Notification) -> CGFloat in
				return .zero
			}
			.subscribe(Subscribers.Assign(object: self, keyPath: \.updatedKeyboardFrameHeight))
	}
}
