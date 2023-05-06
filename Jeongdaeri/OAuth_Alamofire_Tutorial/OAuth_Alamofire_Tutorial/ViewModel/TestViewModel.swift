//
//  TestViewModel.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire
import Combine

class TestViewModel: ObservableObject {
	var subscription = Set<AnyCancellable>()
	
	var timeoutEvent = PassthroughSubject<(), Never>()
	
	init() {
		print("TestViewModel - init() called")
		listenRequestTimeoutError()
	}
	
	// Request Timeout
	func requestTimeoutTest() {
		print("TestViewModel: login() called")
		
		TestAPIService.requestTimeoutTest()
			.sink { (completion: Subscribers.Completion<AFError>) in
				print("TestViewModel requestTimeoutTest completion: \(completion)")
			} receiveValue: { (receivedValue: ()) in
				print("TestViewModel requestTimeoutTest receivedValue: ", receivedValue)
			}
			.store(in: &subscription)
	}
}

// MARK: - Notification
extension TestViewModel {
	func listenRequestTimeoutError() {
		print("TestViewModel - listenRequestTimeoutError")
		
		NotificationCenter.Publisher(center: .default, name: .requestTimeout, object: nil)
			.sink(receiveCompletion: { _ in
				print("Request Timeout Stream Ended")
			}, receiveValue: { _ in
				print("Request Timeout Event Occurred")
				DispatchQueue.main.async {
					self.timeoutEvent.send()
				}
			})
			.store(in: &subscription)
	}
}
