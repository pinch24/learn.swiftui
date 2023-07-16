//
//  OAuthCredential.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire

struct OAuthCredential : AuthenticationCredential {
	
	let accessToken: String
	let refreshToken: String
	
	let expiration: Date
	
	var requiresRefresh: Bool { Date(timeIntervalSinceNow: 10) > expiration }	// 10s
}
