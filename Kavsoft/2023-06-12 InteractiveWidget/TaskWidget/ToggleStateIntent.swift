//
//  ToggleStateIntent.swift
//  InteractiveWidget
//
//  Created by mk on 2023/06/15.
//

import SwiftUI
import AppIntents

struct ToggleStateIntent: AppIntent {
	static var title: LocalizedStringResource = "Toggle Task State"
	
	@Parameter(title: "Task ID")
	var id: String
	
	init() {
		
	}
	
	init(id: String) {
		self.id = id
	}
	
	func perform() async throws -> some IntentResult {
		if let index = TaskDataModel.shared.tasks.firstIndex(where: {
			$0.id == id
		}) {
			TaskDataModel.shared.tasks[index].isCompleted.toggle()
			print("Updated")
		}
		return .result()
	}
}
