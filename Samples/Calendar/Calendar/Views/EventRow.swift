import SwiftUI

struct EventRow: View {
    let event: CalendarEvent
    
    var body: some View {
        HStack(spacing: 12) {
            // Event color indicator
            Circle()
                .fill(event.color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                
                if event.isAllDay {
                    Text("All Day")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text(timeRangeString())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if !event.location.isEmpty {
                    Text(event.location)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if !event.participants.isEmpty {
                    Text(event.participants.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
    
    private func timeRangeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: event.startTime)) - \(formatter.string(from: event.endTime))"
    }
}