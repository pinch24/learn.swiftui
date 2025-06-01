import Foundation

struct DateUtils {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    static func startOfDay(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    static func endOfDay(for date: Date) -> Date {
        let start = startOfDay(for: date)
        return Calendar.current.date(byAdding: .day, value: 1, to: start)!.addingTimeInterval(-1)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int? {
        let calendar = Calendar.current
        guard let startOfStart = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: start)),
              let startOfEnd = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: end)) else {
            return nil
        }
        return calendar.dateComponents([.day], from: startOfStart, to: startOfEnd).day
    }
}