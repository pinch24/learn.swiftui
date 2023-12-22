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
	static let counterStore = Store(initialState: ContentFeature.State()) {
		ContentFeature()
	}
	static let contactsStore = Store(initialState: ContactsFeature.State()) {
		ContactsFeature()
	}
	
    var body: some Scene {
        WindowGroup {
			ContentView(counterStore: TCATutorApp.counterStore, contactsStore: TCATutorApp.contactsStore)
        }
    }
}
