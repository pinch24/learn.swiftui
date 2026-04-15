import SwiftUI

struct NotificationsView: View {
    @State private var pushEnabled = true
    @State private var emailEnabled = true
    @State private var courseUpdates = true
    @State private var promotions = false
    @State private var weeklyDigest = true
    @State private var quietHours = false

    var body: some View {
        Form {
            Section("Channels") {
                Toggle("Push Notifications", isOn: $pushEnabled)
                Toggle("Email", isOn: $emailEnabled)
            }

            Section("Preferences") {
                Toggle("Course Updates", isOn: $courseUpdates)
                Toggle("Promotions", isOn: $promotions)
                Toggle("Weekly Digest", isOn: $weeklyDigest)
            }

            Section {
                Toggle("Quiet Hours (10pm – 8am)", isOn: $quietHours)
            } footer: {
                Text("We won't send push notifications during quiet hours.")
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
