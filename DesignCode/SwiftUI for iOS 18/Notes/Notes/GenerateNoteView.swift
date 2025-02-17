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
					.background(
						RoundedRectangle(cornerRadius: 16)
							.stroke(.primary.opacity(0.1), lineWidth: 1)
					)
					.background(
						RoundedRectangle(cornerRadius: 16)
							.fill(Color(.systemBackground))
					)
				
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
						AnimatedMeshGradient()
							.mask(
								RoundedRectangle(cornerRadius: 16)
									.stroke(lineWidth: 16)
									.blur(radius: 8)
							)
					)
					.overlay(
						RoundedRectangle(cornerRadius: 16)
							.stroke(.white, lineWidth: 3)
							.blur(radius: 2)
							.blendMode(.overlay)
					)
					.overlay(
						RoundedRectangle(cornerRadius: 16)
							.stroke(.white, lineWidth: 1)
							.blur(radius: 1)
							.blendMode(.overlay)
					)
					.background(.black)
					.cornerRadius(16)
					.background(
						RoundedRectangle(cornerRadius: 16)
							.stroke(.black.opacity(0.5), lineWidth: 1)
					)
					.shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20)
					.shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 15)
					.foregroundColor(.white)
				}
				.disabled(isLoading || inputText.isEmpty)
				
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
