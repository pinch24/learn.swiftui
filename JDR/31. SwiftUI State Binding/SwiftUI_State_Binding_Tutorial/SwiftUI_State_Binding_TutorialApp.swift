//
//  SwiftUI_State_Binding_TutorialApp.swift
//  SwiftUI_State_Binding_Tutorial
//
//  Created by mk on 2023/05/03.
//

import SwiftUI

@main
struct SwiftUI_State_Binding_TutorialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(MyViewModel())
        }
    }
}
