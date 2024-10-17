//
//  BookDetailView.swift
//  KakaoBook
//
//  Created by MK on 10/16/24.
//

import SwiftUI

struct BookDetailView: View {
	var book: Book
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				// 도서 이미지
				AsyncImage(url: URL(string: book.thumbnail)) { image in
					image
						.resizable()
						.scaledToFit()
				} placeholder: {
					ProgressView()
				}
				.frame(maxWidth: 200)
				.background(.red)
				
				// 도서 정보
				Text(book.title)
					.titleStyle()
					.padding(.bottom, 8)
				
				Text("저자: \(book.authors.joined(separator: ", "))")
					.calloutStyle()
					.padding(.bottom, 8)
				
				Text("출간일: \(book.datetime.prefix(10))")
					.footnoteStyle()
					.padding(.bottom, 8)
				
				Text("요약내용: \(book.contents)")
					.bodyStyle()
					.padding(.bottom, 8)
				
				Text("정상가: \(book.price)")
					.strikeStyle()
					.padding(.bottom, 8)
				
				Text("할인가: \(book.sale_price)")
					.highlightStyle()
					.padding(.bottom, 8)
				
				Spacer()
			}
			.padding()
		}
	}
}

#Preview {
	var book = Book(
		title: "Murphy's Law",
		contents: "Murphy's Law - popularly known as Sod's Law - with acknowledgements to Parkinson's Law and the Peter Principle - explains the truth of man's existence: that if anything can go wrong, it will. In three volumes of murphology, Arthur Bloch has provided the only comfort possible - laughter - for all those who have ever been exasperated by things going wrong, with a set of rules offering a wise and witty view of the human predicament in the cosmos.",
		url: "https://www.amazon.com/Murphys-Law-Complete-Arthur-Bloch",
		isbn: "9780099445456",
		datetime: "1990-03-03",
		authors: ["Author Bloch"],
		publisher: "Arrow Books Ltd",
		price: 14000,
		sale_price: 9000,
		thumbnail: "https://m.media-amazon.com/images/I/718xoOuLC-L._SY466_.jpg",
		status: "정상판매"
	)
	return BookDetailView(book: book)
}
