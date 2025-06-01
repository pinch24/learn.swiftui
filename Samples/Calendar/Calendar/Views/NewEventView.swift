import SwiftUI

struct NewEventView: View {
    @EnvironmentObject private var viewModel: CalendarViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var title = ""
    @State private var isAllDay = false
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600) // 1 hour later
    @State private var notes = ""
    @State private var location = ""
    @State private var color: Color = .blue
    @State private var participants: [String] = []
    @State private var newParticipant = ""
    
    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    
                    Toggle("All Day", isOn: $isAllDay)
                    
                    if isAllDay {
                        DatePicker("Start", selection: $startDate, displayedComponents: .date)
                        DatePicker("End", selection: $endDate, displayedComponents: .date)
                    } else {
                        DatePicker("Start", selection: $startDate)
                        DatePicker("End", selection: $endDate)
                    }
                    
                    HStack {
                        Text("Color")
                        Spacer()
                        HStack(spacing: 8) {
                            ForEach(colors, id: \.self) { colorOption in
                                Circle()
                                    .fill(colorOption)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: color == colorOption ? 2 : 0)
                                    )
                                    .onTapGesture {
                                        color = colorOption
                                    }
                            }
                        }
                    }
                }
                
                Section {
                    TextField("Location", text: $location)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Participants")
                            .font(.headline)
                        
                        ForEach(participants, id: \.self) { participant in
                            HStack {
                                Text(participant)
                                Spacer()
                                Button(action: {
                                    if let index = participants.firstIndex(of: participant) {
                                        participants.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        HStack {
                            TextField("Add Participant", text: $newParticipant)
                            Button(action: {
                                if !newParticipant.isEmpty {
                                    participants.append(newParticipant)
                                    newParticipant = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section {
                    ZStack(alignment: .topLeading) {
                        if notes.isEmpty {
                            Text("Notes")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                        }
                        TextEditor(text: $notes)
                            .frame(minHeight: 100)
                    }
                }
            }
            .navigationTitle("New Event")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    addEvent()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    private func addEvent() {
        let calendar = Calendar.current
        
        let startTime: Date
        let endTime: Date
        
        if isAllDay {
            startTime = calendar.startOfDay(for: startDate)
            endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!
        } else {
            startTime = startDate
            endTime = endDate
        }
        
        let newEvent = CalendarEvent(
            title: title,
            date: startDate,
            color: color,
            notes: notes,
            isAllDay: isAllDay,
            startTime: startTime,
            endTime: endTime,
            location: location,
            participants: participants
        )
        
        viewModel.addEvent(newEvent)
    }
}