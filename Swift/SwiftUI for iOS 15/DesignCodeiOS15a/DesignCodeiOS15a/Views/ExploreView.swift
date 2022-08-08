//
//  ExploreView.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/08/08.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
		ZStack {
			Color("Background")
				.ignoresSafeArea()
			
			courseSection
				.safeAreaInset(edge: .top, content: {
					Color.clear.frame(height: 70)
				})
				.overlay(NavigationBar(hasScrolled: .constant(true), title: "Recent"))
				.background(Image("Blob 1").offset(x: -100, y: -400))
		}
    }
	
	var courseSection: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 16) {
				ForEach(courses) { course in
					SmallCourseItem(course: course)
				}
			}
			Spacer()
		}
		.padding(.horizontal, 20)
	}
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
