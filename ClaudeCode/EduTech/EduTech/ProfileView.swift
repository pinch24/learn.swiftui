import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            // MARK: - Avatar
            Image(systemName: "person.fill")
                .font(.system(size: 44))
                .foregroundStyle(.primary)
                .frame(width: 96, height: 96)
                .glassEffect(.regular.interactive(), in: .circle)

            VStack(spacing: 6) {
                Text("John Doe")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("john@edutech.io")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // MARK: - Stats
            HStack(spacing: 12) {
                ProfileStat(value: "12", label: "Courses")
                ProfileStat(value: "48", label: "Hours")
                ProfileStat(value: "6", label: "Certificates")
            }
            .padding(.top, 8)

            // MARK: - Options
            GlassEffectContainer(spacing: 0) {
                VStack(spacing: 0) {
                NavigationLink {
                    EditProfileView()
                } label: {
                    ProfileOptionRow(icon: "person.text.rectangle", title: "Edit Profile")
                }
                NavigationLink {
                    NotificationsView()
                } label: {
                    ProfileOptionRow(icon: "bell", title: "Notifications")
                }
                NavigationLink {
                    PrivacyView()
                } label: {
                    ProfileOptionRow(icon: "lock", title: "Privacy")
                }
                NavigationLink {
                    HelpSupportView()
                } label: {
                    ProfileOptionRow(icon: "questionmark.circle", title: "Help & Support")
                }
                }
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .glassEffect(in: .rect(cornerRadius: 18))

            Spacer()
        }
        .padding(20)
        .padding(.top, 20)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileStat: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .glassEffect(in: .rect(cornerRadius: 16))
    }
}

struct ProfileOptionRow: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundStyle(.primary)

                Text(title)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(16)

            Divider()
                .padding(.leading, 56)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
