//
//  WindowView.swift
//  TCAWorks
//
//  Created by MK on 6/3/25.
//

import SwiftUI

struct WindowView: View {
    @State private var currentIndex: Int = 1 // 중간값에서 시작
    private let totalScreens = 3
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    FirstScreenView()
                        .frame(height: UIScreen.main.bounds.height)
                        .id(0)
                    
                    SecondScreenView()
                        .frame(height: UIScreen.main.bounds.height)
                        .id(1)
                    
                    ThirdScreenView()
                        .frame(height: UIScreen.main.bounds.height)
                        .id(2)
                }
				.background(
					GeometryReader { geo in
						Color.clear
							.preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .named("scroll")).minY)
					}
				)
            }
            .scrollTargetBehavior(.paging)
			.coordinateSpace(name: "scroll")
			.onPreferenceChange(ScrollOffsetPreferenceKey.self) { newOffset in
				print("Offset: \(newOffset)")
			}
			.onAppear {
				proxy.scrollTo(1, anchor: .top)
			}
			.ignoresSafeArea()
        }
        .navigationTitle("수직 페이지")
        .navigationBarTitleDisplayMode(.inline)
    }
	
	struct ScrollOffsetPreferenceKey: PreferenceKey {
		static var defaultValue: CGFloat = 0
		static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
			value = nextValue()
		}
	}
}

// 첫 번째 화면
struct FirstScreenView: View {
	var body: some View {
		ZStack {
			Color.red.opacity(0.3)
				.ignoresSafeArea()
			
			VStack {
				Text("첫 번째 화면")
					.font(.largeTitle)
					.fontWeight(.bold)
				
				Image(systemName: "1.circle")
					.resizable()
					.frame(width: 100, height: 100)
					.foregroundColor(.red)
			}
		}
	}
}

// 두 번째 화면
struct SecondScreenView: View {
	var body: some View {
		ZStack {
			Color.blue.opacity(0.3)
				.ignoresSafeArea()
			
			VStack {
				Text("두 번째 화면")
					.font(.largeTitle)
					.fontWeight(.bold)
				
				Image(systemName: "2.circle")
					.resizable()
					.frame(width: 100, height: 100)
					.foregroundColor(.blue)
			}
		}
	}
}

// 세 번째 화면
struct ThirdScreenView: View {
	var body: some View {
		ZStack {
			Color.green.opacity(0.3)
				.ignoresSafeArea()
			
			VStack {
				Text("세 번째 화면")
					.font(.largeTitle)
					.fontWeight(.bold)
				
				Image(systemName: "3.circle")
					.resizable()
					.frame(width: 100, height: 100)
					.foregroundColor(.green)
			}
		}
	}
}

#Preview {
    WindowView()
}
