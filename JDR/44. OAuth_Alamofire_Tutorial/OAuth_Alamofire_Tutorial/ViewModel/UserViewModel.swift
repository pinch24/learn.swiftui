//
//  UserViewModel.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire
import Combine

class UserViewModel: ObservableObject {
	var subscription = Set<AnyCancellable>()
	
	@Published var loggedInUser: UserData? = nil
	@Published var users: [UserData] = []
	
	// Complete Event
	var registerationSuccess = PassthroughSubject<(), Never>()
	var loginSuccess = PassthroughSubject<(), Never>()
	
	// Sign up
	func register(name: String, email: String, password: String) {
		print("UserViewModel: register() called")
		
		AuthAPIService.register(name: name, email: email, password: password)
			.sink { (completion: Subscribers.Completion<AFError>) in
				print("UserViewModel completion: \(completion)")
			} receiveValue: { (receivedUser: UserData) in
				self.loggedInUser = receivedUser
				self.registerationSuccess.send()
			}
			.store(in: &subscription)
	}
	
	// Login
	func login(email: String, password: String) {
		print("UserViewModel: login() called")
		
		AuthAPIService.login(email: email, password: password)
			.sink { (completion: Subscribers.Completion<AFError>) in
				print("UserViewModel completion: \(completion)")
			} receiveValue: { (receivedUser: UserData) in
				self.loggedInUser = receivedUser
				self.loginSuccess.send()
			}
			.store(in: &subscription)
	}
	
	// Current User Info
	func fetchCurrentUserInfo() {
		print("UserViewModel - fetchCurrentUserInfo() called")
		UserAPIService.fetchCurrentUserInfo()
			.sink { (completion: Subscribers.Completion<AFError>) in
				print("UserViewModel completion: \(completion)")
			} receiveValue: { (receivedUser: UserData) in
				print("UserViewModel fetchCurrentUserInfo receivedUser: \(receivedUser)")
				self.loggedInUser = receivedUser
			}
			.store(in: &subscription)
	}
	
	// Fetch All Users
	func fetchUsers() {
		print("UserViewModel - fetchUsers() called")
		UserAPIService.fetchUsers()
			.sink { (completion: Subscribers.Completion<AFError>) in
				print("UserViewModel completion: \(completion)")
			} receiveValue: { (fetchedUsers: [UserData]) in
				print("UserViewModel fetchUsers count: \(fetchedUsers.count)")
				self.users = fetchedUsers
			}
			.store(in: &subscription)
	}
}
