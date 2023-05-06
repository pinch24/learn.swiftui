//
//  AuthAPIService.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire
import Combine

enum AuthAPIService {
	static func register(name: String, email: String, password: String) -> AnyPublisher<UserData, AFError> {
		print("AuthAPIService - register() called")
		
		return APIClient.shared.session
			.request(AuthRouter.register(name: name, email: email, password: password))
			.publishDecodable(type: AuthResponse.self)
			.value()
			.map { receivedValue in
				UserDefaultsManager.shared.setTokens(accessToken: receivedValue.token.accessToken, refreshToken: receivedValue.token.refreshToken)
				return receivedValue.user
			}
			.eraseToAnyPublisher()
	}
	
	static func login(email: String, password: String) -> AnyPublisher<UserData, AFError> {
		print("AuthAPIService - login() called")
		
		return APIClient.shared.session
			.request(AuthRouter.login(email: email, password: password))
			.publishDecodable(type: AuthResponse.self)
			.value()
			.map { receivedValue in
				return receivedValue.user
			}
			.eraseToAnyPublisher()
	}
}
