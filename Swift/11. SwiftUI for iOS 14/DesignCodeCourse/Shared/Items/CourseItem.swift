//
//  CourseItem.swift
//  DesignCodeCourse
//
//  Created by Bob on 2021/06/01.
//

import SwiftUI

struct CourseItem: View {
    
    var course: Course = courses[0]
    #if os(iOS)
    var cornerRadius: CGFloat = 22
    #else
    var cornerRadius: CGFloat = 0
    #endif
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4.0) {
                    
            Spacer()
            
            HStack {
                
                Spacer()
                
                Image(course.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
            }
            
            Text(course.title)
                .fontWeight(.bold)
            
            Text(course.subtitle)
                .font(.footnote)
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .background(course.color)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: course.color.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

struct CourseItem_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CourseItem()
    }
}
