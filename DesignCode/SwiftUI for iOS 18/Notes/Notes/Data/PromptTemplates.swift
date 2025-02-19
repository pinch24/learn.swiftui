//
//  PromptTemplates.swift
//  Notes
//
//  Created by Mk on 2/19/25.
//

import Foundation

struct PromptTemplate: Identifiable {
	let id = UUID()
	let name: String
	let description: String
	let prompt: String
}

struct PromptTemplates {
	static let templates = [
		PromptTemplate(
			name: "Meeting Notes",
			description: "Convert meeting discussions into organized notes with key points and action items",
			prompt: "Create detailed meeting notes from the following discussion points:"
		),
		PromptTemplate(
			name: "Study Notes",
			description: "Transform learning materials into structured study notes with examples",
			prompt: "Transform this content into organized study notes with key points and examples:"
		),
		PromptTemplate(
			name: "Summary",
			description: "Create a concise overview of any text or document",
			prompt: "Provide a concise summary of the following text:"
		),
		PromptTemplate(
			name: "Bullet Points",
			description: "Break down complex information into easy-to-read bullet points",
			prompt: "Convert this text into clear, organized bullet points:"
		)
	]
}
