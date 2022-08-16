//
//  HomeView.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/12.
//

import SwiftUI

struct HomeView: View {
	@Namespace var namespace
	
	@AppStorage("isLiteMode") var isLiteMode = true
	@EnvironmentObject var model: Model
	
	@State var show = false
	@State var showStatusBar = true
	@State var hasScrolled = false
	@State var selectedId = UUID()
	@State var selectedIndex = 0
	@State var showCourse = false
	
    var body: some View {
		ZStack {
			Color("Background")
				.ignoresSafeArea()
			
			ScrollView {
				scrollDetection
				
				featured
				
				Text("Courses".uppercased())
					.font(.footnote.weight(.semibold))
					.foregroundColor(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal, 20)
				
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 20)], spacing: 20) {
					if show == false {
						cards
					}
					else {
						ForEach(courses) { course in
							Rectangle()
								.fill(.white)
								.frame(height: 300)
								.cornerRadius(30)
								.shadow(color: Color("Shadow"), radius: 20, x: 0, y: 10)
								.opacity(0.3)
								.padding(.horizontal, 30)
						}
					}
				}
				.padding(.horizontal, 20)
			}
			.coordinateSpace(name: "scroll")
			.safeAreaInset(edge: .top, content: {
				Color.clear.frame(height: 70)
			})
			.overlay(
				NavigationBar(hasScrolled: $hasScrolled, title: "Featured")
			)
			
			if show {
				detail
			}
		}
		.statusBarHidden(showStatusBar == false)
		.onChange(of: show) { newValue in
			withAnimation(.closeCard) {
				if newValue {
					showStatusBar = false
				}
				else {
					showStatusBar = true
				}
			}
		}
    }
	
	var scrollDetection: some View {
		GeometryReader { proxy in
			//Text("\(proxy.frame(in: .named("scroll")).minY)")
			Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
		}
		.frame(height: 0)
		.onPreferenceChange(ScrollPreferenceKey.self, perform: { value in
			withAnimation(.easeInOut) {
				hasScrolled = value < 0 ? true : false
			}
		})
	}
	
	var featured: some View {
		TabView {
			ForEach(Array(featuredCourses.enumerated()), id: \.offset) { index, course in
				GeometryReader { proxy in
					let minX = proxy.frame(in: .global).minX
					FeaturedItem(course: course)
						.frame(maxWidth: 500)
						.frame(maxWidth: .infinity)
						.padding(.vertical, 40)
						.rotation3DEffect(
							.degrees(minX / -10),
							axis: (x: 1, y: 1, z: 0))
						.shadow(color: Color("Shadow").opacity(isLiteMode ? 0 : 0.3), radius: 5, x: 0, y: 3)
						.blur(radius: abs(minX / 40))
						.overlay(
							Image(course.image)
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(height: 230)
								.offset(x: 32, y: -80)
								.offset(x: minX)
						)
						.onTapGesture {
							showCourse = true
							selectedIndex = index
						}
				}
			}
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
		.frame(height: 430)
		.background(
			Image("Blob 1")
				.offset(x: 250, y: -100)
		)
		.sheet(isPresented: $showCourse) {
			CourseView(show: $showCourse, namespace: namespace, course: featuredCourses[selectedIndex])
		}
	}
	
	var cards: some View {
		ForEach(courses) { course in
			CourseItem(show: $show, namespace: namespace, course: course)
				.onTapGesture {
					withAnimation(.openCard) {
						show.toggle()
						model.showDetail.toggle()
						showStatusBar = false
						selectedId = course.id
					}
				}
		}
	}
	
	var detail: some View {
		ForEach(courses) { course in
			if course.id == selectedId {
				CourseView(show: $show, namespace: namespace, course: course)
					.zIndex(1)
					.transition(.asymmetric(
						insertion: .opacity.animation(.easeInOut(duration: 0.1)),
					removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))))
			}
		}
	}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
			.preferredColorScheme(.dark)
			.previewDevice("iPhone 13 mini")
			.environmentObject(Model())
		
		HomeView()
    }
}
