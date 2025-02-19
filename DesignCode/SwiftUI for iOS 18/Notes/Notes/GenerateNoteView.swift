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
	@State private var showSignUp: Bool = false
	@State private var generatedNotes: String = ""
	@State private var errorMessage: String = ""

	private let apiKey = "..."

	private var openAIService: OpenAIService {
		OpenAIService(apiKey: apiKey)
	}

	private func generateNotes() async {
		guard !inputText.isEmpty else { return }

		isLoading = true
		errorMessage = ""

		do {
			generatedNotes = try await openAIService.generateNotes(from: inputText)
		} catch {
			errorMessage = error.localizedDescription
		}

		isLoading = false
	}

	var body: some View {
		ZStack {
			Color(.systemGray6).edgesIgnoringSafeArea(.all)

			ScrollView {
				VStack(spacing: 20) {
					// First card - Generate Notes
					VStack(spacing: 20) {
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
									.shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
							)

						PrimaryButton(isLoading: isLoading, isDisabled: inputText.isEmpty) {
							Task {
								await generateNotes()
							}
						}

						if !errorMessage.isEmpty {
							Text(errorMessage)
								.foregroundColor(.red)
								.font(.callout)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					}
					.padding(32)
					.background(Color(.systemBackground))
					.cornerRadius(44)
					.shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)

					// Generated Notes card
					if !generatedNotes.isEmpty {
						VStack(alignment: .leading, spacing: 16) {
							Text("Generated Notes")
								.font(.headline)
								.padding(.top)

							Text(generatedNotes)
								.font(.system(.body, design: .serif))
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						.padding(32)
						.background(Color(.systemBackground))
						.cornerRadius(44)
						.shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
					}
				}
				.padding()
				.blur(radius: showSignUp ? 5 : 0)
			}

			VStack {
				HStack {
					Spacer()
					Button(action: {
						withAnimation(.spring()) {
							showSignUp.toggle()
						}
					}) {
						Image(systemName: "person.crop.circle")
							.font(.system(size: 24))
							.foregroundColor(.primary)
							.padding()
							.background(Color(.systemBackground))
							.clipShape(Circle())
							.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
					}
					.padding(.top, 44)
					.padding(.trailing)
				}
				Spacer()
			}

			if showSignUp {
				SignUpView()
					.transition(.move(edge: .top).combined(with: .opacity))
					.zIndex(1)
			}
		}
	}
}

#Preview {
	GenerateNoteView()
}
