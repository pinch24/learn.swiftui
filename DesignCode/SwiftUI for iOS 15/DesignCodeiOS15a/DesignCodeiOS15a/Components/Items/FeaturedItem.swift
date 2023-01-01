//
//  FeaturedItem.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/14.
//

import SwiftUI

struct FeaturedItem: View {
	@Environment(\.sizeCategory) var sizeCategory
	
	var course: Course = courses[0]
	
    var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Spacer()
			Image(course.logo)
				.resizable(resizingMode: .stretch)
				.aspectRatio(contentMode: .fit)
				.frame(width: 26, height: 26)
				.cornerRadius(10)
				.padding(9)
				.background(Color(UIColor.systemBackground).opacity(0.1), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
				.strokeStyle(cornerRadius: 16)
			Text(course.title)
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundStyle(.linearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
				.dynamicTypeSize(.large)
			Text(course.subtitle.uppercased() )
				.font(.footnote)
				.fontWeight(.semibold)
				.foregroundStyle(.secondary)
			Text(course.text)
				.font(.footnote)
				.multilineTextAlignment(.leading)
				.lineLimit(sizeCategory > .large ? 1 : 2)
				.frame(maxWidth: .infinity, alignment: .leading)
				.foregroundColor(.secondary)
		}
		.padding(.all, 20)
		.padding(.vertical, 20)
		.frame(height: 350)
		.background(.ultraThinMaterial)
		.mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
		.strokeStyle()
		.padding(.horizontal, 20)
    }
}

struct FeaturedItem_Previews: PreviewProvider {
    static var previews: some View {
		FeaturedItem()
			.preferredColorScheme(.dark)
			.previewDevice("iPhone 13 mini")
		
        FeaturedItem()
    }
}
