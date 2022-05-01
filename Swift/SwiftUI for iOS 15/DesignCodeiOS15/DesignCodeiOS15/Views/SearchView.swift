//
//  SearchView.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/05/01.
//

import SwiftUI

struct SearchView: View {
	
	@State var text = ""
	@Environment(\.presentationMode) var presentationMode
	
    var body: some View {
		
		NavigationView {
			
			List {
				ForEach(courses.filter { $0.title.contains(text) || text == "" }) { item in
					Text(item.title)
				}
			}
			.searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("SwiftUI, React, UI Desgin"))
			.navigationTitle("Search")
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarItems(
				trailing: Button {
					presentationMode.wrappedValue.dismiss()
				}
				label: {
					Text("Done").bold()
				})
		}
    }
}

struct SearchView_Previews: PreviewProvider {
	
    static var previews: some View {
		
        SearchView()
    }
}
