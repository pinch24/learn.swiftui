//
//  BaseInterceptor.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire

class BaseInterceptor : RequestInterceptor {
	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
		
		var request = urlRequest
		request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
		request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
		
		completion(.success(request))
	}
}
