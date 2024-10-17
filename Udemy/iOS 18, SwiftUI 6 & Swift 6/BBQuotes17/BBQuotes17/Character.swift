//
//  Character.swift
//  BBQuotes17
//
//  Created by MK on 10/14/24.
//

import Foundation

struct Character: Decodable {
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let status: String
    let portrayedBy: String
    var death: Death?
    
    enum CodingKeys: CodingKey {
        case name
        case birthday
        case occupations
        case images
        case aliases
        case status
        case portrayedBy
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        birthday = try container.decode(String.self, forKey: .birthday)
        occupations = try container.decode([String].self, forKey: .occupations)
        images = try container.decode([URL].self, forKey: .images)
        aliases = try container.decode([String].self, forKey: .aliases)
        status = try container.decode(String.self, forKey: .status)
        portrayedBy = try container.decode(String.self, forKey: .portrayedBy)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let deathData = try! Data(contentsOf: Bundle.main.url(forResource: "sampledeath", withExtension: "json")!)
        death = try jsonDecoder.decode(Death.self, from: deathData)
    }
}
