import SwiftUI

struct ContentView: View {
    @State private var isDrawerOpen = false

    var body: some View {
        ZStack(alignment: .leading) {
            NavigationStack {
                HomeView(isDrawerOpen: $isDrawerOpen)
            }
            .disabled(isDrawerOpen)

            // MARK: - Drawer Overlay
            if isDrawerOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isDrawerOpen = false
                        }
                    }
            }

            // MARK: - Drawer Menu
            DrawerMenuView(isOpen: $isDrawerOpen)
                .offset(x: isDrawerOpen ? 0 : -280)
                .animation(.easeInOut(duration: 0.25), value: isDrawerOpen)
        }
    }
}

#Preview {
    ContentView()
}
