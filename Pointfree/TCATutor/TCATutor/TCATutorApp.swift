//
//  TCATutorApp.swift
//  TCATutor
//
//  Created by mk on 12/20/23.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCATutorApp: App {
	static let store = Store(initialState: ContentFeature.State()) {
		ContentFeature()
	}
	
    var body: some Scene {
        WindowGroup {
			ContentView(store: TCATutorApp.store)
        }
    }
}
