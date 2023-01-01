//
//  DesignCodeiOS15aApp.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/05/31.
//

import SwiftUI

@main
struct DesignCodeiOS15aApp: App {
	@StateObject var model = Model()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(model)
		}
	}
}
