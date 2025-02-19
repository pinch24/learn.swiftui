//
//  GenerateNoteCard.swift
//  Notes
//
//  Created by Mk on 2/19/25.
//

import MarkdownUI
import SwiftUI

struct GeneratedNotesCard: View {
	let content: String
	@Binding var isLoading: Bool
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Markdown(content)
				.textSelection(.enabled)
				.markdownTheme(.fancy)
				.padding(.horizontal, 30)
				.overlay(
					ZStack {
						if isLoading {
							AnimatedMeshGradient2().blendMode(colorScheme == .dark ? .softLight : .screen)
							AnimatedMeshGradient2().blendMode(.softLight)
						}
					}
				)
		}
		.padding(.vertical, 30)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(
			RoundedRectangle(cornerRadius: 44, style: .continuous)
				.fill(Color(.systemBackground))
				.shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
		)
		.padding(.horizontal)
	}
}

private extension Theme {
	static let fancy = Theme()
		.text {
			FontSize(.em(0.8))
			ForegroundColor(.primary.opacity(0.7))
		}
		.code {
			FontFamilyVariant(.monospaced)
			FontSize(.em(0.8))
			ForegroundColor(.purple)
			BackgroundColor(.purple.opacity(0.15))
			FontWeight(.medium)
		}
		.codeBlock { configuration in
			ScrollView(.horizontal) {
				configuration.label
					.relativeLineSpacing(.em(0.25))
					.markdownTextStyle {
						FontFamilyVariant(.monospaced)
						FontSize(.em(0.85))
					}
					.padding()
			}
			.background(Color(.secondarySystemBackground))
			.clipShape(RoundedRectangle(cornerRadius: 8))
			.markdownMargin(top: .zero, bottom: .em(0.8))
		}
		.link {
			ForegroundColor(.purple)
		}
		.heading1 { configuration in
			configuration.label
				.fontWeight(.bold)
				.foregroundStyle(.primary)
				.markdownMargin(top: 16, bottom: 8)
		}
		.heading2 { configuration in
			configuration.label
				.font(.body)
				.fontWeight(.semibold)
				.foregroundStyle(.primary.opacity(0.5))
				.markdownMargin(top: 16, bottom: 8)
		}
		.heading3 { configuration in
			configuration.label
				.foregroundStyle(.primary.opacity(0.7))
				.markdownMargin(top: 16, bottom: 8)
		}
		.paragraph { configuration in
			configuration.label
				.relativeLineSpacing(.em(0.25))
				.markdownMargin(top: 0, bottom: 16)
		}
		.listItem { configuration in
			configuration.label
				.markdownMargin(top: .em(0.25))
		}
}

#Preview {
	let markdownText = """
  # Example: Syntax Highlighting with swift-markdown-ui
  
  Here's a Swift code example with syntax highlighting:
  
  ```swift
  import SwiftUI
  
  struct ContentView: View {
   var body: some View {
     Text("Hello, SwiftUI!")
     .padding()
   }
  }
  ```
  """
	
	GeneratedNotesCard(content: markdownText, isLoading: .constant(true))
}
