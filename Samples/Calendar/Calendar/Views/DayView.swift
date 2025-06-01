import SwiftUI

struct DayView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    let date: Date
    
    private let calendar = Calendar.current
    private let hourHeight: CGFloat = 70
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // All-day events section
                if !allDayEvents().isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("All-Day Events")
                            .font(.headline)
                            .padding(.leading)
                        
                        ForEach(allDayEvents()) { event in
                            EventRow(event: event)
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                }
                
                // Time-based events section
                HStack(alignment: .top, spacing: 0) {
                    // Hour labels
                    VStack(alignment: .trailing, spacing: 0) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text("\(hour):00")
                                .font(.caption)
                                .frame(height: hourHeight, alignment: .top)
                                .padding(.top, 2)
                                .padding(.trailing, 5)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 50)
                    
                    // Event area
                    ZStack(alignment: .top) {
                        // Time grid
                        VStack(spacing: 0) {
                            ForEach(0..<24, id: \.self) { hour in
                                Rectangle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                                    .frame(height: hourHeight)
                            }
                        }
                        
                        // Current time indicator
                        if calendar.isDateInToday(date) {
                            CurrentTimeLineView(hourHeight: hourHeight)
                        }
                        
                        // Display events
                        ForEach(timeEvents()) { event in
                            EventView(event: event, hourHeight: hourHeight)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical)
        }
    }
    
    // All-day events
    private func allDayEvents() -> [CalendarEvent] {
        return viewModel.eventsForDate(date).filter { $0.isAllDay }
    }
    
    // Time-based events
    private func timeEvents() -> [CalendarEvent] {
        return viewModel.eventsForDate(date).filter { !$0.isAllDay }
    }
}
