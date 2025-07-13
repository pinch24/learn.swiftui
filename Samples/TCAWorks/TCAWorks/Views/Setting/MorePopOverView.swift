//
//  MorePopOverView.swift
//  TCAWorks
//
//  Created by MK on 7/13/25.
//

import SwiftUI

struct MorePopOverView: View {
	@State private var showPopover = false
	
	var body: some View {
		Button("Show Info") {
			showPopover = true
		}
		.popover(isPresented: $showPopover,
				 attachmentAnchor: .rect(.bounds),
				 arrowEdge: .none) {
			VStack {
				Text("This is a popover")
				Text("It won't be clipped!")
				Text("And can be as large as needed")
			}
			.padding()
			.presentationCompactAdaptation(.popover)
		}
	}
}

#Preview {
    MorePopOverView()
}
