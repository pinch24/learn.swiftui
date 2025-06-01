import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack(spacing: 20) {
            // 월/년 표시
            HStack {
                Text(monthYearString(from: currentMonth))
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 25) {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
            
            // 요일 표시
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(day == "일" ? .red : .primary)
                }
            }
            
            // 날짜 그리드
            MonthView(currentMonth: currentMonth)
                .environmentObject(viewModel)
        }
        .padding(.vertical)
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newDate
        }
    }
}