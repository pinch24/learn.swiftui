//
//  Dex3App.swift
//  Dex3
//
//  Created by MK on 10/19/24.
//

import SwiftUI

@main
struct Dex3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
