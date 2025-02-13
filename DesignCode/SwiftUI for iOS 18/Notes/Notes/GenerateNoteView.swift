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
						RoundedRectangle(cornerRadius: 10)
							.fill(
								LinearGradient(
									colors: gradientColors,
									startPoint: .topLeading,
									endPoint: .bottomTrailing
								)
							)
							.overlay(
								RoundedRectangle(cornerRadius: 10)
									.stroke(
										LinearGradient(
											colors: gradientColors.map { $0.opacity(0.5) },
											startPoint: .topLeading,
											endPoint: .bottomTrailing
										),
										lineWidth: 1
									)
							)
							.shadow(
								color: gradientColors[0].opacity(0.3),
								radius: 8,
								x: 0,
								y: 4
							)
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
