//
//  ContentView.swift
//  KakaoBook
//
//  Created by MK on 10/16/24.
//

import SwiftUI
import Combine

struct ContentView: View {
	@ObservedObject var viewModel = BookViewModel()
	
	@AppStorage("searchList") var searchList: [String] = []		// 검색어 저장 앱 스토리지
	@State var searchText: String = "한강"						// 검색어
	@State var isSearchPresented = false						// 검색 모드: 입력/결과 구분
	
	var body: some View {
		NavigationStack {
			GeometryReader { geometry in
				VStack {
					// 검색 결과 표시
					if isSearchPresented == false {
						if viewModel.books.isEmpty {
							Text("검색 결과가 없습니다.")
						}
						else {
							// 도서 검색 결과 리스트
							searchResultView(geo: geometry)
						}
					}
					
					// 검색어 리스트
					List(searchList, id: \.self) { text in
						Text("\(text)")
							.frame(maxWidth: .infinity, alignment: .leading)
							.contentShape(Rectangle())	// 탭 제스쳐를 텍스트의 여백 영역에서도 이벤트를 받을 수 있도록 영역 확장
							.onTapGesture {
								isSearchPresented = false
								searchBook(text) // 도서 검색 API
							}
					}
					.scrollContentBackground(.hidden)
				}
				.navigationTitle("도서 검색")
				.searchable(text: $searchText, isPresented: $isSearchPresented, prompt: "검색어 입력")
				.onSubmit(of: .search) {
					isSearchPresented = false
					searchBook(searchText) // 도서 검색 API
				}
			}
		}
		.ignoresSafeArea()
		.tint(.indigo)
	}
	
	/// 도서 검색 결과 리스트
	/// - Parameter geo: 전체 화면의 크기 정보를 담고 있는 GeometryProxy, 화면 비율 조정을 위해 필요
	/// - Returns: 검색 결과 뷰
	func searchResultView(geo: GeometryProxy) -> some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(viewModel.books, id: \.isbn) { book in
					VStack(alignment: .leading) {
						NavigationLink(value: book) {
							VStack {
								// 썸네일 이미지
								AsyncImage(url: URL(string: book.thumbnail)) { image in
									image
										.resizable()
										.scaledToFit()
								} placeholder: {
									ProgressView()
								}
								
								// 썸네일 타이틀
								Text("\(book.title)")
									.truncationMode(.tail)
									.lineLimit(1)
									.modifier(ItemModifier())
							}
							.frame(maxWidth: 120)
							.navigationDestination(for: Book.self) { book in
								BookDetailView(book: book)
							}
						}
					}
					.offset(CGSize(width: 16, height: 0))	// 16: 스크롤뷰의 왼쪽 시작 여백
				}
			}
			.padding(.trailing, 32)	// 32: 스크롤뷰의 왼쪽 시작 오프셋 16 + 오른쪽 끝 여백 16
		}
		.frame(height: geo.size.height / 3)	// 스크롤뷰의 높이를 전체 화면 영역의 1/3 크기로 지정
		.tabViewStyle(PageTabViewStyle())
	}
	
	/// 도서 검색 결과 리스트
	/// - Parameter searchText: 검색어
	/// - Returns: Void
	private func searchBook(_ searchText: String) {
		// 최근 검색어 추가 및 정렬
		if searchList.contains(searchText) {
			if let index = searchList.firstIndex(of: searchText) {
				searchList.remove(at: index)	// 이미 기록된 검색어 일 경우 목록 최상단 이동을 위해 삭제
			}
		}
		searchList.insert(searchText, at: 0)	// 입력된 검색어를 목록에 추가
		
		// 도서 검색 API
		viewModel.cancellable = API.fetchData(query: searchText)
			.receive(on: DispatchQueue.main)	// 메인 스레드에서 퍼블리셔 이벤트 처리하도록 지정
			.sink(receiveCompletion: { completion in
				switch completion {
					case .finished:
						print("Data fetching completed.")
					case .failure(let error):
						print("Error occurred: \(error)")
				}
			}, receiveValue: { data in
				viewModel.books = data.documents	// API 결과 전달 -> UI 업데이트
			})
	}
}

/// ViewModel
class BookViewModel: ObservableObject {
	@Published var books: [Book] = []
	var cancellable: AnyCancellable?
}

#Preview {
	ContentView()
}
