import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name = "John Doe"
    @State private var email = "john@edutech.io"
    @State private var bio = "iOS Developer passionate about SwiftUI."

    var body: some View {
        Form {
            Section("Avatar") {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray)
                    Spacer()
                    Button("Change Photo") {}
                        .buttonStyle(.bordered)
                }
                .padding(.vertical, 8)
            }

            Section("Personal Info") {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }

            Section("Bio") {
                TextField("Bio", text: $bio, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { dismiss() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}
