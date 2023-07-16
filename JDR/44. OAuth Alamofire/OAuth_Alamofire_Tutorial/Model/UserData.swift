//
//  UserData.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import Foundation

struct UserData : Codable, Identifiable {
	
	var uuid = UUID()
	
	var id: Int
	var name: String
	var email: String
	var avatar: String
	
	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case email
		case avatar
	}
}
