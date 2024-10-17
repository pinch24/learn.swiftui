//
//  CombineView.swift
//  SwiftUICombine
//
//  Created by MK on 10/16/24.
//

import SwiftUI
import Combine

struct APIView: View {
	@State private var data: Todo? = nil
	@State private var cancellable: AnyCancellable? = nil
	
	var body: some View {
		VStack {
			if let data {
				Text("Received Data:\n\(data)")
					.padding()
			} else {
				Text("-- No Data --")
			}
			
			Button {
				self.cancellable?.cancel()
				self.cancellable = API.fetchData()
					.sink(receiveCompletion: { completion in
						switch completion {
							case .finished:
								print("Data fetching completed.")
							case .failure(let error):
								print("Error occurred: \(error)")
						}
					}, receiveValue: { data in
						self.data = data
					})
			} label: {
				Text("Fetch Data")
					.padding()
					.background(.cyan)
					.clipShape(.rect(cornerRadius: 10))
			}
		}
	}
}

struct API {
	static func fetchData() -> AnyPublisher<Todo, Error> {
		let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
		return URLSession.shared.dataTaskPublisher(for: url)
			.map { $0.data }
			.decode(type: Todo.self , decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}
}

struct Todo: Decodable {
	let userId: Int
	let id: Int
	let title: String
	let completed: Bool
}

#Preview {
	APIView()
}
