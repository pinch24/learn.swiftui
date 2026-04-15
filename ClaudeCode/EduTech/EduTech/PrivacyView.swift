import SwiftUI

struct PrivacyView: View {
    @State private var profileVisible = true
    @State private var shareProgress = false
    @State private var analytics = true
    @State private var personalizedAds = false

    var body: some View {
        Form {
            Section("Profile") {
                Toggle("Public Profile", isOn: $profileVisible)
                Toggle("Share Learning Progress", isOn: $shareProgress)
            }

            Section("Data") {
                Toggle("Usage Analytics", isOn: $analytics)
                Toggle("Personalized Ads", isOn: $personalizedAds)
            }

            Section("Account") {
                NavigationLink("Download My Data") {
                    Text("Data export coming soon.")
                        .navigationTitle("Download Data")
                }
                Button(role: .destructive) {
                } label: {
                    Text("Delete Account")
                }
            }

            Section {
                Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrivacyView()
    }
}
