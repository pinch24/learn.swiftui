//
//  NotificationRow.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/12/29.
//

import SwiftUI

struct NotificationRow: View {
	@State private var subscribed: Bool = true
	
    var body: some View {
		Toggle(isOn: .constant(true)) {
			HStack(spacing: 12) {
				GradientIcon(icon: "bell.fill")
				
				VStack(alignment: .leading) {
					Text("Notify me of new content")
						.font(.subheadline)
						.fontWeight(.semibold)
					
					Text("Max once a week.")
						.font(.caption2)
						.opacity(0.2)
				}
			}
		}
		.toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1))))
    }
}

struct NotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRow()
    }
}
