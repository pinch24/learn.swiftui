import SwiftUI

struct EventListView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    
    var body: some View {
        List {
            // Today's Events
            Section(header: Text("오늘")) {
                let todayEvents = viewModel.eventsForDate(Date())
                if todayEvents.isEmpty {
                    Text("일정 없음")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(todayEvents) { event in
                        EventRow(event: event)
                    }
                }
            }
            
            // Tomorrow's Events
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                Section(header: Text("내일")) {
                    let tomorrowEvents = viewModel.eventsForDate(tomorrow)
                    if tomorrowEvents.isEmpty {
                        Text("일정 없음")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        ForEach(tomorrowEvents) { event in
                            EventRow(event: event)
                        }
                    }
                }
            }
            
            // This Week's Events
            Section(header: Text("이번 주")) {
                let calendar = Calendar.current
                let thisWeekEvents = viewModel.events.filter { event in
                    if let endOfWeek = calendar.date(byAdding: .day, value: 7, to: Date()) {
                        return event.date > Date() && event.date <= endOfWeek && !calendar.isDateInToday(event.date) && !calendar.isDateInTomorrow(event.date)
                    }
                    return false
                }
                
                if thisWeekEvents.isEmpty {
                    Text("일정 없음")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(thisWeekEvents) { event in
                        EventRow(event: event)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}