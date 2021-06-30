//
//  CourcesView.swift
//  DesignCodeCourse
//
//  Created by Bob on 2021/05/30.
//

import SwiftUI

struct CoursesView: View {
    
    @Namespace var namespace
    @Namespace var namespace2
    
    @State var show = false
    @State var selectedItem: Course? = nil
    @State var isDisabled = false
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif
    
    var body: some View {
        
        ZStack {
            
            #if os(iOS)
            if horizontalSizeClass == .compact {
                tabBar
            }
            else {
                sidebar
            }
            fullContent
                .background(VisualEffectBlur(blurStyle: .systemMaterial).edgesIgnoringSafeArea(.all))
            #else
            content
            fullContent
                .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
            #endif
        }
        //.navigationBarTitle("Courses")
    }
    
    var content: some View {
        
        ScrollView {
            
            VStack(spacing: 0) {
                
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 160), spacing: 16)],
                    spacing: 16
                ) {
                    
                    ForEach(courses) { item in
                        
                        VStack {
                            
                            CourseItem(course: item)
                                .matchedGeometryEffect(id: item.id, in: namespace, isSource: !show)
                                .frame(height: 200)
                                .onTapGesture {
                                    withAnimation(.spring(), {
                                        show.toggle()
                                        selectedItem = item
                                        isDisabled = true
                                    })
                                }
                                .disabled(isDisabled)
                        }
                        .matchedGeometryEffect(id: "container\(item.id)", in: namespace, isSource: !show)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 240))]) {
                    ForEach(courseSections) { item in
                        
                        #if os(iOS)
                        NavigationLink(destination: CourseDetail(namespace: namespace2)) {
                            CourseRow(item: item)
                        }
                        #else
                        CourseRow()
                        #endif
                    }
                }
                .padding(16)
            }
        }
        .zIndex(1)
        .navigationTitle("Courses")
    }
    
    @ViewBuilder
    var fullContent: some View {
        
        if selectedItem != nil {
            
            ZStack(alignment: .topTrailing) {
                
                CourseDetail(course: selectedItem!, namespace: namespace)
                
                CloseButton()
                    .padding()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0), {
                            show.toggle()
                            selectedItem = nil
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 0.4,
                                execute: { isDisabled = false }
                            )
                        })
                    }
            }
            .zIndex(2)
            .frame(maxWidth: 712)
            .frame(maxWidth: .infinity)
        }
    }
    
    var tabBar: some View {
        
        TabView {
            
            NavigationView {
                content
            }
            .tabItem {
                Image(systemName: "book.closed")
                Text("Courses")
            }
            
            NavigationView {
                CourseList()
            }
            .tabItem {
                Image(systemName: "list.bullet.rectangle")
                Text("Tutorials")
            }
            
            NavigationView {
                CourseList()
            }
            .tabItem {
                Image(systemName: "tv")
                Text("Livestreams")
            }

            NavigationView {
                CourseList()
            }
            .tabItem {
                Image(systemName: "mail.stack")
                Text("Certificates")
            }

            NavigationView {
                CourseList()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
        }
    }
    
    @ViewBuilder
    var sidebar: some View {
        
        #if os(iOS)
        NavigationView {
            
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
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing,
                            content: { Image(systemName: "person.crop.circle") })
            })
            
            content
        }
        #endif
    }
}

struct CourcesView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CoursesView()
    }
}
