//
//  ContentView.swift
//  APIClient
//
//  Created by MK on 12/24/24.
//

import SwiftUI

struct ContentView: View {
	@State private var imageData: Data?
	@State private var showProgress: Bool = false
	
	var body: some View {
		VStack {
			ZStack {
				if let imageData = imageData, let uiImage = UIImage(data: imageData) {
					Image(uiImage: uiImage)
						.resizable()
						.scaledToFit()
				}
				if showProgress {
					ProgressView()
				}
			}
			Button("Fetch Image") {
				fetchRandomImage()
			}
			.padding()
			.background(Color.blue)
			.foregroundColor(.white)
			.cornerRadius(16)
			.shadow(radius: 8)
		}
	}
	
	func fetchRandomImage() {
		showProgress = true
		let request = HTTPRequest<Data>(method: .GET, url: URL(string: "https://picsum.photos/400/600")!)
		APIClient.request(request) { data in
			showProgress = false
			self.imageData = data
		}
	}
}

#Preview {
	ContentView()
}
