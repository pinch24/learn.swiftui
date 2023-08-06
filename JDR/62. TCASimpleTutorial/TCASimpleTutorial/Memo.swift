//
//  Memo.swift
//  TCASimpleTutorial
//
//  Created by Quasy Kei on 2023/08/06.
//

import Foundation

// MARK: - Memo Element
struct Memo: Codable, Equatable, Identifiable {
    let createdAt, title, viewCount, id: String
}
