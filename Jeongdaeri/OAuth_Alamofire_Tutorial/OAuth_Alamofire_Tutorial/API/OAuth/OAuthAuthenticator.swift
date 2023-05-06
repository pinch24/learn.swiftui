//
//  OAuthAuthenticator.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire

class OAuthAuthenticator : Authenticator {
	// Auth append to Header
	func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
		urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
		//urlRequest.headers.add(name: "ACCESS_TOKEN", value: credential.accessToken)	// if. custom case
	}
	
	// Token Refresh
	func refresh(_ credential: OAuthCredential, for session: Session, completion: @escaping (Result<OAuthCredential, Error>) -> Void) {
		print("OAuthAuthenticator - refresh() called")
		
		let request = session.request(AuthRouter.tokenRefresh)
		request.responseDecodable(of: TokenResponse.self) { result in
			switch result.result {
				case .success(let value):
					UserDefaultsManager.shared.setTokens(accessToken: value.token.accessToken, refreshToken: value.token.refreshToken)
					
					let expiration = Date(timeIntervalSinceNow: 10)	// 10s	// TimeInterval(value.token.expiresIn)
					let newCredential = OAuthCredential(accessToken: value.token.accessToken, refreshToken: value.token.refreshToken, expiration: expiration)
					
					completion(.success(newCredential))
				case .failure(let error):
					completion(.failure(error))
			}
		}
	}
	
	// API Request
	func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
		print("OAuthAuthenticator - didRequest() called")
		
		return false
	}
	
	func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
		return false
	}
}
