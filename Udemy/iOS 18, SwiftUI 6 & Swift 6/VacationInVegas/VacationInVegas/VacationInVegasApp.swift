//
//  VacationInVegasApp.swift
//  VacationInVegas
//
//  Created by MK on 10/13/24.
//

import SwiftUI

@main
struct VacationInVegasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //.modelContainer(for: Place.self)
        .modelContainer(Place.preview)
    }
}
