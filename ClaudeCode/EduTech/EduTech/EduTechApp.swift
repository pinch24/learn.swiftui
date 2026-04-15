//
//  EduTechApp.swift
//  EduTech
//
//  Created by NHN on 4/15/26.
//

import SwiftUI

@main
struct EduTechApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var showLaunch = true

    var body: some View {
        ZStack {
            ContentView()

            if showLaunch {
                LaunchView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2.4))
            withAnimation(.easeInOut(duration: 0.35)) {
                showLaunch = false
            }
        }
    }
}
