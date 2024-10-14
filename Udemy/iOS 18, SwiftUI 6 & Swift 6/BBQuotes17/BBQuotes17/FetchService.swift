//
//  FetchService.swift
//  BBQuotes17
//
//  Created by MK on 10/14/24.
//

import Foundation

struct FetchService {
    enum FetchError: Error {
        case badResponse
    }
    
    let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    // https://breaking-bad-api-six.vercel.app/api/quotes/random?production=Breaking+Bad
    func fetchQuote(from show: String) async throws -> Quote {
        // Build Fetch URL
        let quoteURL = baseURL.appending(path: "quote/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        
        // Fetch Data
        //let response = try await URLSession.shared.data(from: quoteURL)
        
        // Handle Response
        
        // Decode Data
        
        // Reture Quote
        return Quote(quote: "", character: "")
    }
}
