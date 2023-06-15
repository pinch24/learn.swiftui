//
//  TaskWidget.swift
//  TaskWidget
//
//  Created by mk on 2023/06/15.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
		TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let entry = TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		// Fetch Data
		let latestTasks = Array(TaskDataModel.shared.tasks.prefix(3))
		let latestEntries = [TaskEntry(lastThreeTasks: latestTasks)]
        let timeline = Timeline(entries: latestEntries, policy: .atEnd)
        completion(timeline)
    }
}

struct TaskEntry: TimelineEntry {
	let date: Date = .now
	var lastThreeTasks: [TaskModel]
}

struct TaskWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text("Task's")
				.fontWeight(.bold)
				.padding(.bottom, 10)
			
			VStack(alignment: .leading, spacing: 6, content: {
				if entry.lastThreeTasks.isEmpty {
					Text("No Task's Found")
						.font(.caption)
						.foregroundStyle(.gray)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
				else {
					ForEach(entry.lastThreeTasks.sorted {
						!$0.isCompleted && $1.isCompleted
					}) { task in
						HStack(spacing: 6) {
							Button(action: {
								ToggleStateIntent(id: task.id)
							}) {
								Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
									.foregroundStyle(.blue)
							}
							.buttonStyle(.plain)
							
							VStack(alignment: .leading, spacing: 4, content: {
								Text(task.taskTitle)
									.font(.subheadline)
									.lineLimit(1)
									.strikethrough(task.isCompleted, pattern: .solid, color: .primary)
								
								Divider()
							})
						}
						
						if task.id != entry.lastThreeTasks.last?.id {
							Spacer(minLength: 0)
						}
					}
				}
			})
		}
		.padding(.all)
    }
}

struct TaskWidget: Widget {
    let kind: String = "TaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Task Widget")
        .description("This is an example of interactive widget.")
    }
}

struct TaskWidget_Previews: PreviewProvider {
    static var previews: some View {
		TaskWidgetEntryView(entry: TaskEntry(lastThreeTasks: TaskDataModel.shared.tasks))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
