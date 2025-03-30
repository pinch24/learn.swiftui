//
//  BookView.swift
//  SwiftUICombine
//
//  Created by MK on 10/16/24.
//

import SwiftUI
import Combine
import WebKit

struct BookView: View {
	@State private var query: String = "한강"
	@State private var books: [Book]? = nil
	@State private var cancellable: AnyCancellable? = nil
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				if let books {
					List(books, id: \.isbn) { book in
						NavigationLink(value: book) {
							Text("\(book.title)")
						}
					}
					.scrollContentBackground(.hidden)
					.navigationDestination(for: Book.self) { book in
						WebView(urlString: book.url)
					}
				} else {
					Text("-- No Data --")
					Spacer()
				}
			}
			.navigationTitle("Book Search")
			.searchable(text: $query, prompt: "Input Book Info")
			.padding()
			
			Button {
				self.cancellable?.cancel()
				self.cancellable = fetchData(query: query)
					.sink(receiveCompletion: { completion in
						switch completion {
							case .finished:
								print("Data fetching completed.")
							case .failure(let error):
								print("Error occurred: \(error)")
						}
					}, receiveValue: { data in
						self.books = data.documents
					})
			} label: {
				Text("Fetch Data")
					.padding()
					.background(.cyan)
					.cornerRadius(10)
			}
		}
		.tint(.indigo)
		.ignoresSafeArea()
	}
}


func fetchData(query: String) -> AnyPublisher<BookData, Error> {
	let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
	let urlString = "https://dapi.kakao.com/v3/search/book?sort=accuracy&query=\(encodedQuery)"
	let url = URL(string: urlString)!
	
	var request = URLRequest(url: url)
	request.setValue("KakaoAK f4b2cc57ad114a879e40d856b340827d", forHTTPHeaderField: "Authorization")
	request.httpMethod = "GET"
	
	return URLSession.shared.dataTaskPublisher(for: request)
		.map { $0.data }
		.decode(type: BookData.self, decoder: JSONDecoder())
		.eraseToAnyPublisher()
}

struct BookData: Codable {
	let documents: [Book]
	let meta: Meta
}

struct Book: Codable, Hashable {
	let title: String
	let contents: String
	let url: String
	let isbn: String
	let datetime: String
	let authors: [String]
	let publisher: String
	let price: Int
	let sale_price: Int
	let thumbnail: String
	let status: String
}


struct Meta: Codable {
	let total_count: Int
	let pageable_count: Int
	let is_end: Bool
}

struct WebView: UIViewRepresentable {
	let urlString: String
	
	func makeUIView(context: Context) -> WKWebView {
		return WKWebView()
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
		if let url = URL(string: urlString) {
			let request = URLRequest(url: url)
			uiView.load(request)
		}
	}
}

#Preview {
	BookView()
}
