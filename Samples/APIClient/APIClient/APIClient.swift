//
//  APIClient.swift
//  APIClient
//
//  Created by MK on 12/24/24.
//

import Foundation
import Combine

struct APIClient {
	static private var cancellables = Set<AnyCancellable>()
	
	static func request<T: Decodable>(_ request: HTTPRequest<T>, completion: @escaping (T) -> Void) {
		print("API - Request: \(request)")
		let refreshCompletion = completion	// for refreshtoken(request:refreshCompletion:)
		return APIClient.perform(request: request)
			.subscribe(on: DispatchQueue.global(qos: .utility))
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					print("API - Request Completed")
				case .failure(let error):
					switch error {
					case .invalidURL:
						print("API - Request Error: Invalid URL")
					case .responseError(let code):
						print("API - Request Error: Response Code: \(code)")
					case .decodingError:
						print("API - Request Error: Decoding Error")
					case .unauthorized:
						print("API - Request Error: Unauthorized / Token Refresh Required")
						self.refreshToken(request: request, refreshCompletion: refreshCompletion)
					case .unknownError:
						print("API - Request Error: \(error)")
					}
				}
			}, receiveValue: { value in
				completion(value)
				print("API - Request Value: \(value)")
			})
			.store(in: &APIClient.cancellables)
	}
	
	static func perform<T: Decodable>(request: HTTPRequest<T>) -> AnyPublisher<T, APIError> {
		// HTTP URL and Parameters
		guard var components = URLComponents(url: request.url, resolvingAgainstBaseURL: false) else {
			return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
		}
		if let parameters = request.parameters {
			components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		}
		guard let url = components.url else {
			return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
		}
		var urlRequest = URLRequest(url: url)
		
		// HTTP Method
		urlRequest.httpMethod = request.method.rawValue
		// HTTP Headers
		urlRequest.setValue("utf-8", forHTTPHeaderField: "Accept-Charset")
		urlRequest.setValue("APICLIENT_AGENT", forHTTPHeaderField: "User-Agent")
		request.headers?.forEach { key, value in
			urlRequest.setValue(value, forHTTPHeaderField: key)
		}
		// HTTP Body
		if let json = request.jsonValue {
			urlRequest.httpBody = encode(jsonValue: json)
			urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		}
		else if let multipartFormData = request.multipartFormData {
			urlRequest.httpBody = encode(multipartFormData: multipartFormData)
			urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		}
		else if let wwwFormUrl = request.xwwwFormUrlEncoded {
			urlRequest.httpBody = encode(xwwwFormUrlEncoded: wwwFormUrl)
			urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		}
		
		// HTTP - OAuth Refresh
		if let token = TokenManager.shared.getAccessToken() {
			urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		// HTTP
		return URLSession.shared.dataTaskPublisher(for: urlRequest)
//			.tryMap { data, response in
//				guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
//					throw APIError.responseError((response as? HTTPURLResponse)?.statusCode ?? -1)
//				}
//				return data
//			}
//			.decode(type: T.self, decoder: JSONDecoder())
			.tryMap { data, response in
				guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
					throw APIError.responseError((response as? HTTPURLResponse)?.statusCode ?? -1)
				}
				if T.self == Data.self {
					return data as! T
				} else {
					return try JSONDecoder().decode(T.self, from: data)
				}
			}
			.mapError { error -> APIError in
				if let decodingError = error as? DecodingError {
					logDecodingError(decodingError)
					return .decodingError
				}
				switch error {
				case is URLError:
					return .invalidURL
				case is DecodingError:
					return .decodingError
				case APIError.responseError(let statusCode) where statusCode == 401:
					return .unauthorized
				default:
					return .unknownError
				}
			}
			.eraseToAnyPublisher()
	}
	
	private static func encode(jsonValue: [String: String]) -> Data {
		guard let data = try? JSONEncoder().encode(jsonValue) else {
			return Data()
		}
		return data
	}
	
	private static let boundary = "Boundary-\(UUID().uuidString)"
	private static func encode(multipartFormData: [MultipartFormData]) -> Data {
		var data = Data()
		for part in multipartFormData {
			data.append("--\(boundary)\r\n".data(using: .utf8)!)
			if let fileName = part.fileName {
				data.append("Content-Disposition: form-data; name=\"\(part.key)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
			}
			if let mimeType = part.mimeType {
				data.append("Content-Type: \(mimeType)\r\n".data(using: .utf8)!)
			}
			if let value = part.value.data(using: .utf8) {
				data.append("\(value)\r\n".data(using: .utf8)!)
			}
			data.append("\r\n".data(using: .utf8)!)
		}
		data.append("--\(boundary)\r\n".data(using: .utf8)!)
		return data
	}
	
	private static func encode(xwwwFormUrlEncoded: [String: String]) -> Data {
		var data = Data()
		for (key, value) in xwwwFormUrlEncoded {
			data.append("\(key)=\(value)".data(using: .utf8)!)
			data.append("&".data(using: .utf8)!)
		}
		return data
	}
	
	private static func logDecodingError(_ error: DecodingError) {
		switch error {
		case .dataCorrupted(let context):
			print("Decoding Error: Data corrupted - \(context.debugDescription)")
			if let codingPath = context.codingPath.first {
				print("Coding Path: \(codingPath)")
			}
		case .keyNotFound(let key, let context):
			print("Decoding Error: Key '\(key.stringValue)' not found - \(context.debugDescription)")
			print("Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
		case .valueNotFound(let value, let context):
			print("Decoding Error: Value '\(value)' not found - \(context.debugDescription)")
			print("Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
		case .typeMismatch(let type, let context):
			print("Decoding Error: Type mismatch for type '\(type)' - \(context.debugDescription)")
			print("Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
		@unknown default:
			print("Decoding Error: Unknown error occurred.")
		}
	}
	
	private static func refreshToken<T: Decodable>(request: HTTPRequest<T>, refreshCompletion: @escaping (T) -> Void) {
		TokenManager.shared.refreshToken()
			.subscribe(on: DispatchQueue.global(qos: .utility))
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					print("API - Refresh token completed")
					self.request(request, completion: refreshCompletion)
				case .failure(let error):
					print("API - Refresh token failed: \(error.localizedDescription)")
				}
			}, receiveValue: { _ in
				// OAuth Token Action
			})
			.store(in: &cancellables)
	}
}

struct HTTPRequest<T: Decodable>: Decodable {
	let method: HTTPMethod
	let url: URL
	var parameters: [String: String]?
	var headers: [String: String]?
	//var body: Data?
	var jsonValue: [String: String]?
	var multipartFormData: [MultipartFormData]?
	var xwwwFormUrlEncoded: [String: String]?
}

struct MultipartFormData: Decodable {
	var key: String
	var value: String
	var fileName: String?
	var mimeType: String?
}

enum HTTPMethod: String, Codable {
	case GET
	case POST
	case PUT
	case DELETE
}

enum ResultType: String, Codable {
	case JSON
	case DATA
}

enum APIError: Error, Equatable {
	case invalidURL
	case responseError(Int)
	case decodingError
	case unauthorized
	case unknownError
	
	var errorDescription: String? {
		switch self {
		case .invalidURL: return "API - Error: Invalid URL"
		case .responseError(let code): return "API - Error: Response: \(code)"
		case .decodingError: return "API - Error: Decoding"
		case .unauthorized: return "API - Error: Unauthorized"
		case .unknownError: return "API - Error: Unknown"
		}
	}
}
