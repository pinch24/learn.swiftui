//
//  ContentView.swift
//  Notes
//
//  Created by Mk on 2/13/25.
//

import SwiftUI
import CoreLocation

struct Note: Identifiable {
	let id = UUID()
	var title: String
	var content: String
	var date: Date
	var location: String?
	var colorTag: Color
}

class NotesViewModel: ObservableObject {
	@Published var notes: [Note] = []

	func addNote(title: String, content: String, date: Date, location: String?, colorTag: Color) {
		let note = Note(title: title, content: content, date: date, location: location, colorTag: colorTag)
		notes.append(note)
	}

	func deleteNote(at offsets: IndexSet) {
		notes.remove(atOffsets: offsets)
	}
}

struct ContentView: View {
	@StateObject private var viewModel = NotesViewModel()
	@State private var showingNewNoteSheet = false
	@State private var newNoteTitle = ""
	@State private var newNoteContent = ""
	@State private var newNoteLocation = ""
	@State private var selectedColor: Color = .blue
	@State private var selectedDate: Date = Date()

	var body: some View {
		NavigationView {
			Group {
				if viewModel.notes.isEmpty {
					VStack(spacing: 20) {
						Image(systemName: "note.text")
							.font(.system(size: 60))
							.foregroundColor(.gray)
						Text("No Notes Yet")
							.font(.title2)
							.fontWeight(.medium)
						Text("Tap + to create your first note")
							.foregroundColor(.gray)
					}
				} else {
					List {
						ForEach(viewModel.notes) { note in
							VStack(alignment: .leading, spacing: 8) {
								HStack {
									Circle()
										.fill(note.colorTag)
										.frame(width: 12, height: 12)
									Text(note.title)
										.font(.headline)
								}
								Text(note.content)
									.font(.body)
									.foregroundColor(.gray)
								HStack {
									if let location = note.location {
										Image(systemName: "location.fill")
											.foregroundColor(.gray)
										Text(location)
											.font(.caption)
											.foregroundColor(.gray)
									}
									Spacer()
									Text(note.date, style: .date)
										.font(.caption)
								}
							}
							.padding(.vertical, 8)
						}
						.onDelete(perform: viewModel.deleteNote)
					}
				}
			}
			.navigationTitle("Notes")
			.toolbar {
				Button(action: {
					showingNewNoteSheet = true
				}) {
					Image(systemName: "plus")
				}
			}
			.sheet(isPresented: $showingNewNoteSheet) {
				NavigationView {
					Form {
						TextField("Title", text: $newNoteTitle)
						TextEditor(text: $newNoteContent)
							.frame(height: 200)
						TextField("Location (optional)", text: $newNoteLocation)

						Section(header: Text("Date")) {
							DatePicker(
								"Note Date",
								selection: $selectedDate,
								displayedComponents: [.date, .hourAndMinute]
							)
						}

						Section(header: Text("Color Tag")) {
							ColorPicker("Choose a color", selection: $selectedColor)
								.padding(.vertical, 8)
						}
					}
					.navigationTitle("New Note")
					.navigationBarItems(
						leading: Button("Cancel") {
							showingNewNoteSheet = false
							resetForm()
						},
						trailing: Button("Save") {
							if !newNoteTitle.isEmpty {
								viewModel.addNote(
									title: newNoteTitle,
									content: newNoteContent,
									date: selectedDate,
									location: newNoteLocation.isEmpty ? nil : newNoteLocation,
									colorTag: selectedColor
								)
								showingNewNoteSheet = false
								resetForm()
							}
						}
						.disabled(newNoteTitle.isEmpty)
					)
				}
			}
		}
	}

	private func resetForm() {
		newNoteTitle = ""
		newNoteContent = ""
		newNoteLocation = ""
		selectedColor = .blue
		selectedDate = Date()
	}
}

#Preview {
	ContentView()
}
