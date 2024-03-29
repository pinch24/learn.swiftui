//
//  SmallCourseItem.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/08/08.
//

import SwiftUI

struct SmallCourseItem: View {
	var course: Course = courses[0]
	
    var body: some View {
		VStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(.black.opacity(0.1))
				.overlay(
					Image(course.image)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 150, height: 105)
				)
			Text(course.subtitle)
				.font(.caption)
				.foregroundColor(.secondary)
				.lineLimit(1)
			Text(course.title)
				.fontWeight(.semibold)
				.frame(maxWidth: .infinity, alignment: .leading)
		}
		.padding()
		.frame(width: 160, height: 200)
		.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
		.strokeStyle(cornerRadius: 30)
    }
}

struct SmallCourseItem_Previews: PreviewProvider {
    static var previews: some View {
        SmallCourseItem()
    }
}
