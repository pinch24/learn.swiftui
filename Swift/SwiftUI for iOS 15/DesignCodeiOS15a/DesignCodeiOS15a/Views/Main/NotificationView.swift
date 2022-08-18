//
//  NotificationView.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/08/18.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
		ZStack {
			
			Color("Background")
				.ignoresSafeArea()
			
			ScrollView {
				sectionsSection
			}
			.safeAreaInset(edge: .top, content: {
				Color.clear.frame(height: 70)
			})
			.overlay(NavigationBar(hasScrolled: .constant(true), title: "Notifications"))
			.background(Image("Blob 1").offset(x: -180, y: 300))
		}
    }
	
	var sectionsSection: some View {
		VStack(alignment: .leading) {
			ForEach(Array(courseSections.enumerated()), id: \.offset) { index, section in
				if index > 0 { Divider() }
				SectionRow(section: section)
			}
		}
		.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
		.strokeStyle(cornerRadius: 30)
		.padding(20)
	}
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
