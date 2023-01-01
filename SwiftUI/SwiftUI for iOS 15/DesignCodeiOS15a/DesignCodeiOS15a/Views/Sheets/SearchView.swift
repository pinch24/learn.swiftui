//
//  SearchView.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/28.
//

import SwiftUI

struct SearchView: View {
	@Environment(\.presentationMode) var presentationMode
	
	@Namespace var namespace
	
	@State var text = ""
	@State var show = false
	@State var selectedIndex = 0
	
    var body: some View {
		NavigationView {
			ScrollView {
				VStack {
					content
				}
				.padding(20)
				.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
				.strokeStyle(cornerRadius: 30)
				.padding(20)
				.background(
					Rectangle()
						.fill(.regularMaterial)
						.frame(height: 200)
						.frame(maxHeight: .infinity, alignment: .top)
						.blur(radius: 20)
						.offset(y: -200)
				)
				.background(Image("Blob 1").offset(x: -100, y: -200))
			}
			.searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("SwiftUI, React, UI Design")) {
				ForEach(suggestions) { suggestion in
					Button {
						text = suggestion.text
					} label: {
						Text(suggestion.text)
							.searchCompletion(suggestion.text)
					}

				}
			}
			.navigationTitle("Search")
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarItems(trailing: Button { presentationMode.wrappedValue.dismiss() } label: { Text("Done").bold() })
			.sheet(isPresented: $show) {
				CourseView(show: $show, namespace: namespace, course: courses[selectedIndex])
			}
		}
    }
	
	var content: some View {
		ForEach(Array(courses.enumerated()), id: \.offset) { index, item in
			if item.title.contains(text) || text == "" {
				if index > 0 { Divider() }
				Button {
					show = true
					selectedIndex = index
				} label: {
					HStack(alignment: .top, spacing: 12) {
						Image(item.image)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: 44, height: 44)
							.background(Color("Background"))
							.mask(Circle())
						VStack(alignment: .leading) {
							Text(item.title)
								.bold()
								.foregroundColor(.primary)
							Text(item.text)
								.font(.footnote)
								.foregroundColor(.secondary)
								.frame(maxWidth: .infinity, alignment: .leading)
								.multilineTextAlignment(.leading)
						}
					}
					.padding(.vertical, 4)
					.listRowSeparator(.hidden)
				}
			}
		}
	}
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
