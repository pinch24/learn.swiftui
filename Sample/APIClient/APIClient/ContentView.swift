//
//  ContentView.swift
//  APIClient
//
//  Created by MK on 12/24/24.
//

import SwiftUI

struct ContentView: View {
	@State private var imageData: Data?
	
	var body: some View {
		VStack {
			if let imageData = imageData, let uiImage = UIImage(data: imageData) {
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFit()
			} else {
				Text("Loading image...")
			}
		}
		.task {
			fetchRandomImage()
		}
	}
	
	func fetchRandomImage() {
		let request = HTTPRequest<Data>(method: .GET, url: URL(string: "https://picsum.photos/400/600")!)
		APIClient.request(request) { data in
			self.imageData = data
		}
	}
}

#Preview {
	ContentView()
}
