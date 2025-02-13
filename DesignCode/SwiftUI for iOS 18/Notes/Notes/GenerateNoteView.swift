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
	@State private var gradientColors: [Color] = [
		Color(hex: "78e1fb"),
		Color(hex: "7a9def"),
		Color(hex: "0d82ea"),
		Color(hex: "c580ef"),
	]
	
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
					.background(
						MeshGradient(width: 3, height: 3, points: [
							.init(0, 0), .init(0.5, 0), .init(1, 0),
							.init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
							.init(0, 1), .init(0.5, 1), .init(1, 1)
						], colors: [
							.blue, .purple, .indigo,
							.orange, .white, .blue,
							.yellow, .green, .mint
						])
						.cornerRadius(16)
					)
					.foregroundColor(.white)
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
