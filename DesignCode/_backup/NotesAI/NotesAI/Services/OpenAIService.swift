import Foundation

class OpenAIService {
    private let apiKey: String
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    init() {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            fatalError("OPENAI_API_KEY not found in environment variables")
        }
        self.apiKey = apiKey
    }
    
    func streamGenerateNotes(from text: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                let messages: [[String: Any]] = [
                    ["role": "system", "content": """
                    You are a helpful assistant that generates clear, structured notes from text.
                    Always format your response in markdown with:
                    - Clear headings using #
                    - Bullet points for key items
                    - **Bold** for important terms
                    - Use proper markdown formatting for lists and subpoints
                    """],
                    ["role": "user", "content": "Please generate notes from this text: \(text)"]
                ]
                
                let requestBody: [String: Any] = [
                    "model": "gpt-4o",
                    "messages": messages,
                    "temperature": 0.7,
                    "stream": true
                ]
                
                var request = URLRequest(url: URL(string: endpoint)!)
                request.httpMethod = "POST"
                request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
                
                let (result, response) = try await URLSession.shared.bytes(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                
                for try await line in result.lines {
                    if line.hasPrefix("data: "),
                       let data = line.dropFirst(6).data(using: .utf8),
                       let response = try? JSONDecoder().decode(StreamResponse.self, from: data),
                       let text = response.choices.first?.delta.content {
                        continuation.yield(text)
                    }
                }
                continuation.finish()
            }
        }
    }
}

struct StreamResponse: Codable {
    let choices: [StreamChoice]
}

struct StreamChoice: Codable {
    let delta: StreamDelta
}

struct StreamDelta: Codable {
    let content: String?
}

enum APIError: Error {
    case invalidResponse
} 
