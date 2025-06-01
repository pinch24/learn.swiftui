import Foundation
import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var color: Color
    var notes: String
    var isAllDay: Bool
    var startTime: Date
    var endTime: Date
    var location: String
    var participants: [String]
}
