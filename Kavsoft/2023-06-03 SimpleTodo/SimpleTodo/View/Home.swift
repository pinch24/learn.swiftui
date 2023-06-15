//
//  Home.swift
//  SimpleTodo
//
//  Created by mk on 2023/06/15.
//

import SwiftUI

struct Home: View {
	@Environment(\.self) private var env
	
	@State private var filterDate: Date = .init()
	@State private var showPendingTasks: Bool = true
	@State private var showCompletedTasks: Bool = true
	
    var body: some View {
		List {
			DatePicker(selection: $filterDate, displayedComponents: [.date]) {
				
			}
			.labelsHidden()
			.datePickerStyle(.graphical)
			
			CustomFilteringDataView(filterDate: $filterDate) { pendingTasks, completedTasks in
				DisclosureGroup(isExpanded: $showPendingTasks) {
					if pendingTasks.isEmpty {
						Text("No Task's Found")
							.font(.caption)
							.foregroundColor(.gray)
					}
					else {
						ForEach(pendingTasks) {
							TaskRow(task: $0, isPendingTask: true)
						}
					}
				} label: {
					Text("Pending Task's \(pendingTasks.isEmpty ? "" : "(\(pendingTasks.count))")")
						.font(.caption)
						.foregroundColor(.gray)
				}
				
				DisclosureGroup(isExpanded: $showCompletedTasks) {
					if completedTasks.isEmpty {
						Text("No Task's Found")
							.font(.caption)
							.foregroundColor(.gray)
					}
					else {
						ForEach(completedTasks) {
							TaskRow(task: $0, isPendingTask: false)
						}
					}
				} label: {
					Text("Completed Task's \(completedTasks.isEmpty ? "" : "(\(completedTasks.count))")")
						.font(.caption)
						.foregroundColor(.gray)
				}
			}
		}
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Button {
					do {
						let task = Task(context: env.managedObjectContext)
						task.id = .init()
						task.date = filterDate
						task.title = ""
						task.isCompleted = false
						
						try env.managedObjectContext.save()
						showPendingTasks = true
					}
					catch {
						print(error.localizedDescription)
					}
				} label: {
					HStack {
						Image(systemName: "plus.circle.fill")
							.font(.title3)
						
						Text("New Task")
					}
					.fontWeight(.bold)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct TaskRow: View {
	@ObservedObject var task: Task
	var isPendingTask: Bool
	
	@Environment(\.self) private var env
	@FocusState private var showKeyboard: Bool
	
	var body: some View {
		HStack {
			HStack(spacing: 12) {
				Button {
					task.isCompleted.toggle()
					save()
				} label: {
					Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
						.font(.title)
						.foregroundColor(.blue)
				}
				.buttonStyle(.plain)
				
				VStack(alignment: .leading, spacing: 4) {
					TextField("Task Title", text: .init(get: {
						return task.title ?? ""
					}, set: { value in
						task.title = value
					}))
					.focused($showKeyboard)
					.onSubmit {
						removeEmptyTask()
						save()
					}
					.foregroundColor(isPendingTask ? .primary : .gray)
					.strikethrough(isPendingTask == false, pattern: .dash, color: .primary)
					
					Text((task.date ?? .init()).formatted(date: .omitted, time: .shortened))
						.font(.callout)
						.foregroundColor(.gray)
						.overlay {
							DatePicker(selection: .init(get: {
								return task.date ?? .init()
							}, set: { value in
								task.date = value
								save()
							}), displayedComponents: [.hourAndMinute]) {
								
							}
							.labelsHidden()
							.blendMode(.destinationOver)
						}
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
			.onAppear {
				if (task.title ?? "").isEmpty {
					showKeyboard = true
				}
			}
			.onDisappear {
				removeEmptyTask()
				save()
			}
			.onChange(of: env.scenePhase) { newValue in
				if newValue != .active {
					showKeyboard = false
					DispatchQueue.main.async {
						removeEmptyTask()
						save()
					}
				}
			}
			.swipeActions(edge: .trailing, allowsFullSwipe: true) {
				Button(role: .destructive) {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
						env.managedObjectContext.delete(task)
						save()
					}
				} label: {
					Image(systemName: "trash.fill")
				}
			}
		}
	}
	
	func save() {
		do {
			try env.managedObjectContext.save()
		}
		catch {
			print(error.localizedDescription)
		}
	}
	
	func removeEmptyTask() {
		if (task.title ?? "").isEmpty {
			env.managedObjectContext.delete(task)
		}
	}
}
