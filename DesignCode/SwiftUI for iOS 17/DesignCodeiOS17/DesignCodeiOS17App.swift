//
//  DesignCodeiOS17App.swift
//  DesignCodeiOS17
//
//  Created by mk on 2023/06/19.
//

import SwiftUI

@main
struct DesignCodeiOS17App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.dynamicTypeSize(.xSmall ... .xxLarge)
				.preferredColorScheme(.dark)
        }
    }
}
