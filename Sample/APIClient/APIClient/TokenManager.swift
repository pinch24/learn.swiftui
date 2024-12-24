//
//  TokenManager.swift
//  APIClient
//
//  Created by MK on 12/24/24.
//

import Foundation
import Combine

class TokenManager {
	@Published private(set) var token: OAuthToken?
	private var cancellables: Set<AnyCancellable> = []
	
	static let shared = TokenManager()
	
	init(token: OAuthToken? = nil) {
		self.token = token
	}
	
	func updateToken(with token: OAuthToken) {
		self.token = token
	}
	
	func getAccessToken() -> String? {
		return self.token?.accessToken
	}
	
	func refreshToken() -> Future<Bool, Error> {
		Future { promise in
			guard let refreshToken = self.token?.refreshToken else {
				promise(.failure(APIError.unauthorized))
				return
			}
			
			#warning("Implement refresh token logig: URL")
			let url = URL(string: "https://api.twitter.com/oauth2/token")!
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
			request.httpBody = "grant_type=refresh_token&refresh_token=\(refreshToken)".data(using: .utf8)
			
			URLSession.shared.dataTask(with: request) { data, response, error in
				if let error {
					promise(.failure(error))
					return
				}
				
				guard let data else {
					promise(.failure(APIError.invalidURL))
					return
				}
				
				do {
					let decodedToken = try JSONDecoder().decode(OAuthToken.self, from: data)
					self.updateToken(with: decodedToken)
					promise(.success(true))
				}
				catch {
					promise(.failure(APIError.decodingError))
				}
			}.resume()
		}
	}
}

struct OAuthToken: Codable {
	let accessToken: String
	let refreshToken: String
	let expiresIn: Int
	let issuedAt: Date
	
	var isExpired: Bool { Date().timeIntervalSince(issuedAt) > Double(expiresIn) }
}
