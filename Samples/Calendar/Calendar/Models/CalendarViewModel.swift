import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var events: [CalendarEvent] = []
    @Published var selectedDate: Date = Date()
    @Published var displayMode: DisplayMode = .month
    @Published var showNewEventSheet = false

    enum DisplayMode {
        case day, week, month, year
    }

    init() {
        loadSampleEvents()
    }

    private func loadSampleEvents() {
        let calendar = Calendar.current
        let today = Date()

        // Sample events for today
        events.append(CalendarEvent(title: "Design Meeting",
                                    date: today,
                                    color: .blue,
                                    notes: "App design review",
                                    isAllDay: false,
                                    startTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today)!,
                                    endTime: calendar.date(bySettingHour: 11, minute: 30, second: 0, of: today)!,
                                    location: "Conference Room A",
                                    participants: ["John Doe", "Jane Smith"]))

        // Sample events for tomorrow
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) {
            events.append(CalendarEvent(title: "Doctor Appointment",
                                        date: tomorrow,
                                        color: .red,
                                        notes: "Regular check-up",
                                        isAllDay: false,
                                        startTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: tomorrow)!,
                                        endTime: calendar.date(bySettingHour: 15, minute: 0, second: 0, of: tomorrow)!,
                                        location: "City Hospital",
                                        participants: []))
        }

        // Sample events for next week
        if let nextWeek = calendar.date(byAdding: .day, value: 7, to: today) {
            events.append(CalendarEvent(title: "Birthday Party",
                                        date: nextWeek,
                                        color: .pink,
                                        notes: "Prepare gifts",
                                        isAllDay: true,
                                        startTime: calendar.startOfDay(for: nextWeek),
                                        endTime: calendar.date(bySettingHour: 23, minute: 59, second: 59, of: nextWeek)!,
                                        location: "Friend's House",
                                        participants: ["Friend1", "Friend2", "Friend3"]))
        }
    }

    func eventsForDate(_ date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        return events.filter { event in
            calendar.isDate(event.date, inSameDayAs: date)
        }
    }

    func addEvent(_ event: CalendarEvent) {
        events.append(event)
    }
}