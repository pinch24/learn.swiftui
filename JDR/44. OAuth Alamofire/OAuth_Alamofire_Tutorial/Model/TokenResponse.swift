//
//  TokenResponse.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation

struct TokenResponse: Codable {
	let message: String
	let token: TokenData
}
