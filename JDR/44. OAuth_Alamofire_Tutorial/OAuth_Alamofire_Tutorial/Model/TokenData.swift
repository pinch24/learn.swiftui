//
//  TokenData.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation

struct TokenData: Codable {
	let tokenType: String = "Bearer"
	let expiresIn: Int = 0
	let accessToken: String
	let refreshToken: String

	enum CodingKeys: String, CodingKey {
		case tokenType = "token_type"
		case expiresIn = "expires_in"
		case accessToken = "access_token"
		case refreshToken = "refresh_token"
	}
}
