//
//  GenerateNoteView.swift
//  Notes
//
//  Created by Mk on 2/13/25.
//

import SwiftUI

struct GenerateNoteView: View {
	@State private var inputText: String = ""
	@State private var isLoading: Bool = false
	
	var body: some View {
		ZStack {
			Color(.systemGray6).edgesIgnoringSafeArea(.all)
			
			VStack (spacing: 20) {
				Text("Generate Notes")
					.font(.title)
					.fontWeight(.bold)
					.frame(maxWidth: .infinity, alignment: .leading)
				
				Text("Transform your thoughts into well-structured notes using artificial intelligence.")
					.font(.subheadline)
					.foregroundStyle(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
				
				TextEditor(text: $inputText)
					.frame(height: 200)
					.padding()
					.background(RoundedRectangle(cornerRadius: 10)
						.fill(Color(.systemGray6)))
				
				Button(action: {}) {
					HStack {
						if isLoading {
							ProgressView()
								.tint(.white)
						} else {
							Image(systemName: "sparkles")
						}
						Text(isLoading ? "Generating..." : "Generate Notes")
					}
					.padding()
					.frame(maxWidth: .infinity)
					.background(Color.blue)
					.foregroundColor(.white)
					.cornerRadius(10)
				}
				.disabled(isLoading || inputText.isEmpty)
				.padding(.horizontal)
				
				Spacer()
			}
			.padding()
			.background(Color(.systemBackground))
			.cornerRadius(44)
			.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
			.padding()
		}
	}
}

#Preview {
	GenerateNoteView()
}
