//
//  TestAPIService.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire
import Combine

enum TestAPIService {
	static func requestTimeoutTest() -> AnyPublisher<(), AFError> {
		print("TestAPIService - requestTimeoutTest() called")
		
		return APIClient.shared.session
			.request(TestRouter.requestTimeout)
			.publishDecodable(type: UserInfoResponse.self)
			.value()
			.map { receivedValue in return () }
			.eraseToAnyPublisher()
	}
}


