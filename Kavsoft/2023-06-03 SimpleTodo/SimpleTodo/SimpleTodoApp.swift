//
//  SimpleTodoApp.swift
//  SimpleTodo
//
//  Created by Mk on 3/6/25.
//

import SwiftUI

@main
struct SimpleTodoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
