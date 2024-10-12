//
//  DesignCodeiOS15App.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/04/01.
//

import SwiftUI

@main
struct DesignCodeiOS15App: App {
	
	@StateObject var model = Model()
	
    var body: some Scene {
		
        WindowGroup {
			
            ContentView()
				.environmentObject(model)
        }
    }
}
