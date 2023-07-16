//
//  OAuth_Alamofire_TutorialApp.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/05.
//

import SwiftUI

@main
struct OAuth_Alamofire_TutorialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(UserViewModel())
        }
    }
}
