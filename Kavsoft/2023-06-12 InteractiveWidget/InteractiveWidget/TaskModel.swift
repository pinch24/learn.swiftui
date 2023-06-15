//
//  TaskModel.swift
//  InteractiveWidget
//
//  Created by mk on 2023/06/15.
//

import SwiftUI

struct TaskModel: Identifiable {
	var id: String = UUID().uuidString
	var taskTitle: String
	var isCompleted: Bool = false
	
	/// Other Properties
}

/// Sample Data Model
class TaskDataModel {
	static let shared = TaskDataModel()
	
	var tasks: [TaskModel] = [
		.init(taskTitle: "Record Video!"),
		.init(taskTitle: "Edit Video"),
		.init(taskTitle: "Publish it")
	]
}
