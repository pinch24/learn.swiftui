//
//  OpenAIService.swift
//  Notes
//
//  Created by Mk on 2/19/25.
//

import Foundation

struct Message: Codable {
	let role: String
	let content: String
}

struct Choice: Codable {
	let message: Message
	let finishReason: String?
	
	enum CodingKeys: String, CodingKey {
		case message
		case finishReason = "finish_reason"
	}
}

struct ChatCompletionResponse: Codable {
	let id: String
	let object: String
	let created: Int
	let model: String
	let choices: [Choice]
	let usage: Usage
}

struct Usage: Codable {
	let promptTokens: Int
	let completionTokens: Int
	let totalTokens: Int
	
	enum CodingKeys: String, CodingKey {
		case promptTokens = "prompt_tokens"
		case completionTokens = "completion_tokens"
		case totalTokens = "total_tokens"
	}
}

struct StreamCompletionResponse: Codable {
	struct Choice: Codable {
		struct Delta: Codable {
			let content: String?
		}
		
		let delta: Delta
		let finishReason: String?
		
		enum CodingKeys: String, CodingKey {
			case delta
			case finishReason = "finish_reason"
		}
	}
	
	let id: String
	let object: String
	let created: Int
	let model: String
	let choices: [Choice]
}

class OpenAIService {
	private let apiKey: String
	private let urlSession = URLSession.shared
	private let jsonDecoder = JSONDecoder()
	
	init(apiKey: String) {
		self.apiKey = apiKey
	}
	
	func generateNotes(from text: String) async throws -> String {
		let endpoint = "https://api.openai.com/v1/chat/completions"
		guard let url = URL(string: endpoint) else {
			throw URLError(.badURL)
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let messages = [
			Message(role: "system", content: "You are a helpful assistant that generates well-structured notes from given text."),
			Message(role: "user", content: "Please convert this text into well-structured notes: \(text)")
		]
		
		let requestBody: [String: Any] = [
			"model": "gpt-4o",
			"messages": messages.map { ["role": $0.role, "content": $0.content] },
			"temperature": 0.7
		]
		
		request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
		
		let (data, response) = try await urlSession.data(for: request)
		
		guard let httpResponse = response as? HTTPURLResponse else {
			throw URLError(.badServerResponse)
		}
		
		guard httpResponse.statusCode == 200 else {
			throw URLError(.badServerResponse)
		}
		
		let completionResponse = try jsonDecoder.decode(ChatCompletionResponse.self, from: data)
		return completionResponse.choices.first?.message.content ?? "No response generated"
	}
	
	func streamNotes(from text: String) -> AsyncThrowingStream<String, Error> {
		AsyncThrowingStream { continuation in
			Task {
				let endpoint = "https://api.openai.com/v1/chat/completions"
				guard let url = URL(string: endpoint) else {
					continuation.finish(throwing: URLError(.badURL))
					return
				}
				
				var request = URLRequest(url: url)
				request.httpMethod = "POST"
				request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
				request.addValue("application/json", forHTTPHeaderField: "Content-Type")
				
				let messages = [
					Message(role: "system", content: "You are a helpful assistant that generates well-structured notes from given text."),
					Message(role: "user", content: "Please convert this text into well-structured notes: \(text)")
				]
				
				let requestBody: [String: Any] = [
					"model": "gpt-4",
					"messages": messages.map { ["role": $0.role, "content": $0.content] },
					"temperature": 0.7,
					"stream": true
				]
				
				request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
				
				let (result, response) = try await urlSession.bytes(for: request)
				
				guard let httpResponse = response as? HTTPURLResponse else {
					continuation.finish(throwing: URLError(.badServerResponse))
					return
				}
				
				guard httpResponse.statusCode == 200 else {
					continuation.finish(throwing: URLError(.badServerResponse))
					return
				}
				
				for try await line in result.lines {
					if line.hasPrefix("data: "), let data = line.dropFirst(6).data(using: .utf8) {
						if line.contains("[DONE]") {
							continuation.finish()
							return
						}
						
						do {
							let streamResponse = try JSONDecoder().decode(StreamCompletionResponse.self, from: data)
							if let content = streamResponse.choices.first?.delta.content {
								continuation.yield(content)
							}
						} catch {
							print("Decoding error: \(error)")
						}
					}
				}
				
				continuation.finish()
			}
		}
	}
}
