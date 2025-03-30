//
//  Utilities.swift
//  KakaoBook
//
//  Created by MK on 10/16/24.
//

import Foundation

/// secret.json 파일에서 key에 해당하는 value 값 로드
func loadAPIKey(_ key: String) -> String? {
	if let url = Bundle.main.url(forResource: "secret", withExtension: "json") {
		do {
			let data = try Data(contentsOf: url)	// secret.json 파일 로드
			if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
			   let value = json[key] as? String {	// key에 해당하는 value를 지정
				return value
			}
		} catch {
			print("Error reading JSON file: \(error)")
		}
	}
	return nil
}
