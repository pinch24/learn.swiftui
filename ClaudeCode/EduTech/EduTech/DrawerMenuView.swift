import SwiftUI

struct DrawerMenuView: View {
    @Binding var isOpen: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - Profile Header
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "person.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.primary)
                    .frame(width: 56, height: 56)
                    .glassEffect(.regular.interactive(), in: .circle)

                Text("John Doe")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("john@edutech.io")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 24)

            Divider()

            // MARK: - Menu Items
            VStack(alignment: .leading, spacing: 4) {
                DrawerMenuItem(icon: "house.fill", title: "Home")
                DrawerMenuItem(icon: "book.fill", title: "My Courses")
                DrawerMenuItem(icon: "bookmark.fill", title: "Bookmarks")
                DrawerMenuItem(icon: "bell.fill", title: "Notifications")
                DrawerMenuItem(icon: "gearshape.fill", title: "Settings")
            }
            .padding(.top, 16)

            Spacer()

            Divider()

            DrawerMenuItem(icon: "arrow.left.square", title: "Sign Out")
                .padding(.top, 16)
        }
        .padding(24)
        .frame(width: 280, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(.regularMaterial)
    }
}

struct DrawerMenuItem: View {
    let icon: String
    let title: String

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundStyle(.primary)

                Text(title)
                    .foregroundStyle(.primary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}
