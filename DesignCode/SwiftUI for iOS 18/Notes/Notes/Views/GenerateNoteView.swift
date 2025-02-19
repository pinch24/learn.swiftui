//
//  GenerateNoteView.swift
//  Notes
//
//  Created by Mk on 2/13/25.
//

import SwiftUI
import MarkdownUI

struct GenerateNoteView: View {
	@State private var inputText: String = ""
	@State private var generatedNotes: String = ""
	@State private var isLoading: Bool = false
	@State private var errorMessage: String?
	@State private var isAnimating: Bool = false
	@State private var scrollToTop: Bool = false
	@State private var isScrolledDown: Bool = false
	
	private let openAIService = OpenAIService()
	
	var body: some View {
		ZStack {
			Color(.systemGray6)
				.ignoresSafeArea()
			
			ScrollView {
				ScrollViewReader { proxy in
					VStack(spacing: 32) {
						NotesCard(
							inputText: $inputText,
							isLoading: $isLoading,
							isAnimating: $isAnimating,
							errorMessage: errorMessage
						) {
							await generateNotes()
						}
						
						// Generated Notes Card
						if !generatedNotes.isEmpty {
							GeneratedNotesCard(content: generatedNotes, isLoading: $isLoading)
								.id("generatedNotes")
								.transition(.asymmetric(
									insertion: .opacity.animation(.easeInOut.delay(0.3)),
									removal: .opacity.animation(.easeInOut)
								))
						}
					}
					.id("top")
					.padding(.vertical, 30)
					.background(GeometryReader { geometry -> Color in
						let offset = geometry.frame(in: .named("scroll")).minY
						if offset < -100 && !isScrolledDown {
							DispatchQueue.main.async {
								isScrolledDown = true
							}
						} else if offset >= -100 && isScrolledDown {
							DispatchQueue.main.async {
								isScrolledDown = false
							}
						}
						return Color.clear
					})
					.onChange(of: generatedNotes) {
						if !generatedNotes.isEmpty {
							withAnimation {
								proxy.scrollTo("generatedNotes", anchor: .bottom)
							}
						}
					}
					.onChange(of: scrollToTop) { _, newValue in
						if newValue {
							withAnimation {
								proxy.scrollTo("top", anchor: .top)
							}
							scrollToTop = false
						}
					}
				}
			}
			.coordinateSpace(name: "scroll")
			
			if isLoading {
				AnimatedMeshGradient()
					.mask(
						RoundedRectangle(cornerRadius: 44, style: .continuous)
							.stroke(lineWidth: 44)
							.blur(radius: 22)
					)
					.ignoresSafeArea()
			}
			
			if !generatedNotes.isEmpty && isScrolledDown {
				CircleButton(icon: "arrow.up") {
					scrollToTop = true
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
				.padding(.bottom, 20)
			}
		}
	}
	
	func generateNotes() async {
		withAnimation(.easeInOut(duration: 1).delay(0.5)) {
			isLoading = true
		}
		errorMessage = nil
		generatedNotes = ""
		
		do {
			let stream = try await openAIService.streamGenerateNotes(from: inputText)
			for try await text in stream {
				generatedNotes += text
			}
		} catch {
			errorMessage = "Error: \(error.localizedDescription)"
		}
		
		isLoading = false
	}
}

#Preview {
	GenerateNoteView()
}
