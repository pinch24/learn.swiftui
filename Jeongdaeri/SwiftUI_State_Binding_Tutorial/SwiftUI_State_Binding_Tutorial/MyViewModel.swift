//
//  MyViewModel.swift
//  SwiftUI_State_Binding_Tutorial
//
//  Created by mk on 2023/05/03.
//

import Foundation
import Combine

class MyViewModel: ObservableObject {
	@Published var appTitle : String = "빡코딩의 일상!!!!"
}
