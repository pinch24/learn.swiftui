//
//  UserAPIService.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire
import Combine

enum UserAPIService {
	static func fetchUsers() -> AnyPublisher<[UserData], AFError> {
		print("UserAPIService - fetchUsers() called")
		
		let storedTokenData = UserDefaultsManager.shared.getTokens()
		let credential = OAuthCredential(accessToken: storedTokenData.accessToken, refreshToken: storedTokenData.refreshToken, expiration: Date(timeIntervalSinceNow: 10))	// 10s
		
		let authenticator = OAuthAuthenticator()
		let authInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
		
		return APIClient.shared.session
			.request(UserRouter.fetchUsers, interceptor: authInterceptor)
			.publishDecodable(type: UserListResponse.self)
			.value()
			.map { $0.data }
			.eraseToAnyPublisher()
	}
	
	static func fetchCurrentUserInfo() -> AnyPublisher<UserData, AFError> {
		print("UserAPIService - fetchCurrentInfo() called")
		
		let storedTokenData = UserDefaultsManager.shared.getTokens()
		let credential = OAuthCredential(accessToken: storedTokenData.accessToken, refreshToken: storedTokenData.refreshToken, expiration: Date(timeIntervalSinceNow: 10))	// 10s
		
		let authenticator = OAuthAuthenticator()
		let authInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
		
		return APIClient.shared.session
			.request(UserRouter.fetchCurrentInfo, interceptor: authInterceptor)
			.publishDecodable(type: UserInfoResponse.self)
			.value()
			.map { $0.user }
			.eraseToAnyPublisher()
	}
}

