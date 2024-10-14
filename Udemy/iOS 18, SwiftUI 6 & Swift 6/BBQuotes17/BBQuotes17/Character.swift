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
    let death: Death?
}
