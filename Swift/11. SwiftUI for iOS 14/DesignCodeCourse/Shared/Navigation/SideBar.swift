//
//  SideBar.swift
//  DesignCodeCourse
//
//  Created by Bob on 2021/05/31.
//

import SwiftUI

struct SideBar: View {
    
    var body: some View {
        
        NavigationView {
            
			#if os(iOS)
			content
				.navigationTitle("Learn")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing,
                                content: { Image(systemName: "person.crop.circle") })
                })
			#else
			content
				.frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
                .toolbar(content: {
                    ToolbarItem(placement: .automatic,
                                content: {
                                    Button(action: {}, label: {
                                        Image(systemName: "person.crop.circle")
                                    })
                                })
                })
			#endif
			
			CoursesView()
        }
    }
	
	var content: some View {
		
		List {
			
			NavigationLink(
				destination: CoursesView(),
				label: {
					Label("Courses", systemImage: "book.closed")
				})
			
			Label("Tutorials", systemImage: "list.bullet.rectangle")
			Label("Livestreams", systemImage: "tv")
			Label("Certificates", systemImage: "mail.stack")
			Label("Search", systemImage: "magnifyingglass")
		}
		.listStyle(SidebarListStyle())
		.navigationTitle("Learn")
	}
}

struct SideBar_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            SideBar()
        }
    }
}
