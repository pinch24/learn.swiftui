//
//  LiteModeRow.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/12/29.
//

import SwiftUI

struct LiteModeRow: View {
	@State private var isLiteMode: Bool = true
	
    var body: some View {
		Toggle(isOn: $isLiteMode) {
			HStack(spacing: 12) {
				GradientIcon(icon: "speedometer")
				
				VStack(alignment: .leading) {
					Text("Lite Mode")
						.font(.subheadline)
						.fontWeight(.semibold)
					
					Text("Better performance. Recommended for iPhone X and order.")
						.font(.caption2)
						.opacity(0.2)
				}
			}
		}
		.toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1))))
    }
}

struct LiteModeRow_Previews: PreviewProvider {
    static var previews: some View {
        LiteModeRow()
    }
}
