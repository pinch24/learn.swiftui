//
//  NavigationBar.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/14.
//

import SwiftUI

struct NavigationBar: View {
	@AppStorage("showModal") var showModal = false
	@Binding var hasScrolled: Bool
	@State var showSearch = false
	@State var showAccount = false
	
	var title = ""
	
    var body: some View {
		ZStack {
			Color.clear
				.background(.ultraThinMaterial)
				.blur(radius: 10)
				.opacity(hasScrolled ? 1 : 0)
			
			Text(title)
				.animatableFont(size: hasScrolled ? 22 : 34, weight: .bold)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.leading, 20)
				.padding(.top, 20)
				.offset(y: hasScrolled ? -4 : 0)
			
			HStack(spacing: 16) {
				Button {
					showSearch = true
				} label: {
					Image(systemName: "magnifyingglass")
						.font(.body.weight(.bold))
						.frame(width: 36, height: 36)
						.foregroundColor(.secondary)
						.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
						.strokeStyle(cornerRadius: 14)
				}
				.sheet(isPresented: $showSearch) {
					SearchView()
				}
				
				Button {
					//showAccount = true
					withAnimation {
						showModal = true
					}
				} label: {
					AvatarView()
				}
				.sheet(isPresented: $showAccount) {
					AccountView()
				}
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
			.padding(.trailing, 20)
			.padding(.top, 20)
			.offset(y: hasScrolled ? -4 : 0)
		}
		.frame(height: hasScrolled ? 44 : 70)
		.frame(maxHeight: .infinity, alignment: .top)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
		NavigationBar(hasScrolled: .constant(false), title: "Featured")
    }
}
