//
//  TCATouchApp.swift
//  TCATouch
//
//  Created by mk on 12/26/23.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCATouchApp: App {
    static let counterStore = Store(initialState: CounterFeature.State(), reducer: {
        CounterFeature()
    })
    
    var body: some Scene {
        WindowGroup {
            ContentView(counterStore: TCATouchApp.counterStore)
        }
    }
}
