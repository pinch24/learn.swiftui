//
//  FeaturedItem.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/04/17.
//

import SwiftUI

struct FeaturedItem: View {
	
	var course: Course = courses[0]
	
    var body: some View {
		
		VStack(alignment: .leading, spacing: 8.0) {
			
			Spacer()
			
			Image(course.logo)
				.resizable(resizingMode: .stretch)
				.aspectRatio(contentMode: .fit)
				.frame(width: 26.0, height: 26.0)
				.cornerRadius(1)
				.padding(9)
				.background(.ultraThinMaterial,
							in: RoundedRectangle(cornerRadius: 16, style: .continuous))
				.strokeStyle(cornerRadius: 16)
				
			Text(course.title)
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundStyle(
					.linearGradient(
						colors: [.primary, .primary.opacity(0.5)],
						startPoint: .topLeading,
						endPoint: .bottomTrailing))
				.lineLimit(1)
			
			Text(course.subtitle .uppercased())
				.font(.footnote)
				.fontWeight(.semibold)
				.foregroundColor(.secondary)
			
			Text(course.text)
				.font(.footnote)
				.multilineTextAlignment(.leading)
				.lineLimit(2)
				.frame(maxWidth: .infinity, alignment: .leading)
				.foregroundColor(.secondary)
		}
		.padding(/*@START_MENU_TOKEN@*/.all, 20.0/*@END_MENU_TOKEN@*/)
		.padding(.vertical, 20)
		.frame(height: 350.0)
		.background(.ultraThinMaterial,
					in: RoundedRectangle(cornerRadius: 30, style: .continuous))
		//.cornerRadius(/*@START_MENU_TOKEN@*/30.0/*@END_MENU_TOKEN@*/)
		//.mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
		.shadow(color: Color("Shadow").opacity(0.3), radius: 10, x: 0, y: 10)
		.strokeStyle()
		.padding(.horizontal, 20)
		.overlay(
			Image(course.image)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: 230)
			.offset(x: 32, y: -80))
    }
}

struct FeaturedItem_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedItem()
    }
}
