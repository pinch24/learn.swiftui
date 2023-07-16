//
//  UserRouter.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire

enum UserRouter: URLRequestConvertible {
	case fetchUsers
	case fetchCurrentInfo
	
	var baseURL: URL {
		return URL(string: APIClient.BASE_URL)!
	}
	
	var endPoint: String {
		switch self {
			case .fetchUsers:
				return "user/all"
			case .fetchCurrentInfo:
				return "user/info"
			//default:
			//	return ""
		}
	}
	
	var method: HTTPMethod {
		switch self {
			case .fetchUsers:
				return .get
			case .fetchCurrentInfo:
				return .get
			//default:
			//	return .get
		}
	}
	
	var parameters: Parameters {
		switch self {
			default:
				return Parameters()
		}
	}
	
	func asURLRequest() throws -> URLRequest {
		let url = baseURL.appendingPathComponent(endPoint)
		
		var request = URLRequest(url: url)
		request.method = method
		
		return request
	}
}
