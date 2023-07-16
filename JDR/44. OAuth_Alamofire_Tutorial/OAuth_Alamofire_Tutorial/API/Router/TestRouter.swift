//
//  TestRouter.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire

enum TestRouter: URLRequestConvertible {
	case requestTimeout
	
	var baseURL: URL {
		switch self {
			case .requestTimeout:
				return URL(string: "https://dev-roughgears-req.free.beeceptor.com")!
		}
	}
	
	var endPoint: String {
		switch self {
			case .requestTimeout:
				return "/request-timeout"
			//default:
			//	return ""
		}
	}
	
	var method: HTTPMethod {
		switch self {
			case .requestTimeout:
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

