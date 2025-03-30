//
//  Item.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
