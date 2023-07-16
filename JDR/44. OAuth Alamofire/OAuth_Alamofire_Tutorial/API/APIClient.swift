//
//  APIClient.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire

final class APIClient {
	static let shared = APIClient()
	
	static let BASE_URL = "https://phplaravel-574671-2229990.cloudwaysapps.com/api/"
	
	let interceptors = Interceptor(interceptors: [
		BaseInterceptor()	// application/json
	])
	
	let monitors = [APILogger()] as [EventMonitor]
	
	var session: Session
	
	init() {
		print("APIClient - init() called")
		session = Session(interceptor: interceptors, eventMonitors: monitors)
	}
}
