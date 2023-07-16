//
//  AuthResponse.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation

struct AuthResponse : Codable {
	var user: UserData
	var token: TokenData
	
	enum CodingKeys: String, CodingKey {
		case user
		case token
	}
}
