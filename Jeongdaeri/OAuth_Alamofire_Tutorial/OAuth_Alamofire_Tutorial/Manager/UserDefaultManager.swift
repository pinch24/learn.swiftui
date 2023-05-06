//
//  UserDefaultManager.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation

class UserDefaultsManager {
	enum Key: String, CaseIterable {
		case accessToken, refreshToken
	}
	
	static let shared: UserDefaultsManager = {
		return UserDefaultsManager()
	}()
	
	// Clear Tokens
	func clearAll() {
		print("UserDefaultManager - clearAll() called")
		Key.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
	}
	
	// Set Tokens
	func setTokens(accessToken: String, refreshToken: String) {
		print("UserDefaultManager - setTokens() called")
		UserDefaults.standard.set(accessToken, forKey: Key.accessToken.rawValue)
		UserDefaults.standard.set(refreshToken, forKey: Key.refreshToken.rawValue)
		UserDefaults.standard.synchronize()
	}
	
	// Get Tokens
	func getTokens() -> TokenData {
		let accessToken = UserDefaults.standard.string(forKey: Key.accessToken.rawValue)
		let refreshToken = UserDefaults.standard.string(forKey: Key.refreshToken.rawValue)
		return TokenData(accessToken: accessToken ?? "", refreshToken: refreshToken ?? "")
	}
}
