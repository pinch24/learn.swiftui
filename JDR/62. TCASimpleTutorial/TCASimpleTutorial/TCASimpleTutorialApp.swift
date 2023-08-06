//
//  TCASimpleTutorialApp.swift
//  TCASimpleTutorial
//
//  Created by mk on 2023/07/16.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCASimpleTutorialApp: App {
	let counterStore = Store(initialState: CounterState(), reducer: counterReducer, environment: CounterEnvironment())
    let memoStore = Store(initialState: MemoState(), reducer: memoReducer, environment: MemoEnvironment(memoClient: MemoClient.live, mainQueue: .main))
	
    var body: some Scene {
        WindowGroup {
            // CounterView(store: counterStore)
            MemoView(store: memoStore)
        }
    }
}
