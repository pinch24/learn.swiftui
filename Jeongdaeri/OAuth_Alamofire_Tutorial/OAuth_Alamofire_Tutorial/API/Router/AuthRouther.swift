//
//  AuthRouther.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
	case register(name: String, email: String, password: String)
	case login(email: String, password: String)
	case tokenRefresh
	
	var baseURL: URL {
		return URL(string: APIClient.BASE_URL)!
	}
	
	var endPoint: String {
		switch self {
			case .register:
				return "user/register"
			case .login:
				return "user/login"
			case .tokenRefresh:
				return "user/token-refresh"
			//default:
			//	return ""
		}
	}
	
	var method: HTTPMethod {
		switch self {
			case .register:
				return .post
			case .login:
				return .post
			case .tokenRefresh:
				return .post
			//default:
			//	return .get
		}
	}
	
	var parameters: Parameters {
		switch self {
			case let .login(email, password):
				var params = Parameters()
				params["email"] = email
				params["password"] = password
				return params
				
			case .register(let name, let email, let password):
				var params = Parameters()
				params["name"] = name
				params["email"] = email
				params["password"] = password
				return params
				
			case .tokenRefresh:
				var params = Parameters()
				params["refresh_token"] = UserDefaultsManager.shared.getTokens()
				return params
		}
	}
	
	func asURLRequest() throws -> URLRequest {
		let url = baseURL.appendingPathComponent(endPoint)
		
		var request = URLRequest(url: url)
		request.method = method
		request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
		
		return request
	}
}
