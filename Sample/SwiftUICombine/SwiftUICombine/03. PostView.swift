//
//  PostView.swift
//  SwiftUICombine
//
//  Created by MK on 10/16/24.
//

import SwiftUI
import Combine

struct PostView: View {
	@ObservedObject var viewModel = PostViewModel()
	
	var body: some View {
		NavigationView {
			List(viewModel.posts, id: \.id) { post in
				VStack(alignment: .leading) {
					Text(post.title)
						.font(.headline)
					Text(post.body)
						.font(.body)
						.foregroundColor(.gray)
				}
			}
			.navigationBarTitle("Posts")
		}
	}
}

struct Post: Decodable {
	let id: Int
	let title: String
	let body: String
}

class PostViewModel: ObservableObject {
	@Published var posts: [Post] = []
	
	private var cancellable: AnyCancellable?
	
	init() {
		fetchPosts()
	}
	
	func fetchPosts() {
		let urlString = "https://jsonplaceholder.typicode.com/posts"
		guard let url = URL(string: urlString) else { return }
		
		cancellable = URLSession.shared.dataTaskPublisher(for: url)
			.map(\.data)
			.decode(type: [Post].self, decoder: JSONDecoder())
			.replaceError(with: [])
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] posts in
				self?.posts = posts
			})
	}
}

#Preview {
	PostView()
}
