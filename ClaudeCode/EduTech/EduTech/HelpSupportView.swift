import SwiftUI

struct HelpSupportView: View {
    private let faqs: [FAQ] = [
        FAQ(question: "How do I enroll in a course?",
            answer: "Browse the Home tab, tap a course card, then tap Enroll to start learning."),
        FAQ(question: "Can I learn offline?",
            answer: "Yes. Downloaded lessons are available offline from the Downloads section."),
        FAQ(question: "How do I get a certificate?",
            answer: "Complete all lessons and the final quiz of a course to earn a certificate."),
        FAQ(question: "How do I cancel my subscription?",
            answer: "Go to Settings › Subscription › Manage Plan to cancel anytime.")
    ]

    var body: some View {
        List {
            Section("Contact") {
                Link(destination: URL(string: "mailto:support@edutech.io")!) {
                    Label("Email Support", systemImage: "envelope")
                }
                Link(destination: URL(string: "https://example.com/chat")!) {
                    Label("Live Chat", systemImage: "bubble.left.and.bubble.right")
                }
            }

            Section("FAQ") {
                ForEach(faqs) { faq in
                    DisclosureGroup(faq.question) {
                        Text(faq.answer)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 4)
                    }
                }
            }

            Section("Resources") {
                Link("User Guide", destination: URL(string: "https://example.com/guide")!)
                Link("Community Forum", destination: URL(string: "https://example.com/forum")!)
                Link("Report a Bug", destination: URL(string: "https://example.com/bug")!)
            }

            Section {
                HStack {
                    Text("App Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct FAQ: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

#Preview {
    NavigationStack {
        HelpSupportView()
    }
}
