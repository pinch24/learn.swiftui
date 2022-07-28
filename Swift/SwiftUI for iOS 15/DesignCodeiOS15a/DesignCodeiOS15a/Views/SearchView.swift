//
//  SearchView.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/28.
//

import SwiftUI

struct SearchView: View {
	
	@Environment(\.presentationMode) var presentationMode
	
	@State var text = ""
	
    var body: some View {
		
		NavigationView {
			List {
				ForEach(courses.filter { $0.title.contains(text) || text == "" }) { item in
					Text(item.title)
				}
			}
			.searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("SwiftUI, React, UI Design"))
			.navigationTitle("Search")
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarItems(trailing: Button { presentationMode.wrappedValue.dismiss() } label: { Text("Done").bold() })
		}
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
