//
//  API.swift
//  KakaoBook
//
//  Created by MK on 10/16/24.
//

import Foundation
import Combine

struct API {
	/// 도서 검색 API
	static func fetchData(query: String) -> AnyPublisher<BookData, Error> {
		let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
		let urlString = "https://dapi.kakao.com/v3/search/book?sort=accuracy&query=\(encodedQuery)"
		let url = URL(string: urlString)!
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		if let apiKey = loadAPIKey("KakaoAPIKey") {										// Kakao API Key(secret.json)
			request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")	// HTTP Authorization
		} else {
			print("API Key not found in apikeys.json")
		}
		
		return URLSession.shared.dataTaskPublisher(for: request)
			.map { $0.data }
			.decode(type: BookData.self, decoder: JSONDecoder())
			.map { data in	// 필터링: "정상판매" 상태만 허용
				BookData(documents: data.documents.filter { $0.status == "정상판매" }, meta: data.meta)
			}
			.eraseToAnyPublisher()
	}
}
