//
//  ContentView.swift
//  Notes
//
//  Created by Mk on 2/13/25.
//

import SwiftUI

struct Note: Identifiable {
	let id = UUID()
	var title: String
	var content: String
	var date: Date
}

class NotesViewModel: ObservableObject {
	@Published var notes: [Note] = []

	func addNote(title: String, content: String) {
		let note = Note(title: title, content: content, date: Date())
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
	
	var body: some View {
		NavigationView {
			List {
				if viewModel.notes.isEmpty {
					ContentUnavailableView(
						"No Notes",
						systemImage: "note.text",
						description: Text("Tap the plus button to create a new note")
					)
				} else {
					ForEach(viewModel.notes) { note in
						VStack(alignment: .leading, spacing: 8) {
							Text(note.title)
								.font(.headline)
							Text(note.content)
								.font(.body)
								.foregroundColor(.gray)
							Text(note.date, style: .date)
								.font(.caption)
						}
						.padding(.vertical, 8)
					}
					.onDelete(perform: viewModel.deleteNote)
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
					}
					.navigationTitle("New Note")
					.navigationBarItems(
						leading: Button("Cancel") {
							showingNewNoteSheet = false
							newNoteTitle = ""
							newNoteContent = ""
						},
						trailing: Button("Save") {
							if !newNoteTitle.isEmpty {
								viewModel.addNote(title: newNoteTitle, content: newNoteContent)
								showingNewNoteSheet = false
								newNoteTitle = ""
								newNoteContent = ""
							}
						}
						.disabled(newNoteTitle.isEmpty)
					)
				}
			}
		}
	}
}

#Preview {
	ContentView()
}
