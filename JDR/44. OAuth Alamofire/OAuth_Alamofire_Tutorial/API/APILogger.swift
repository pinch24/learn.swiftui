//
//  APILogger.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation
import Alamofire

final class APILogger: EventMonitor {
	let queue = DispatchQueue(label: "OAuth_Alamofire_Tutorial_APILogger")

	func requestDidResume(_ request: Request) {
		print("APILogger - Resuming: \(request)")
	}

	func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
		print("APILogger - request() called")
		
		if let error = response.error {
			switch error {
				case let .sessionTaskFailed(error: error):
					print("APILogger Error - error: ", error)
					if error._code == NSURLErrorTimedOut {
						print("[API Timeout] Time out occurs!!!!")
						NotificationCenter.default.post(name: .requestTimeout, object: nil)
					}
				default:
					print("default")
			}
		}
		
		debugPrint("APILogger - Finished: \(response)")
	}
}
