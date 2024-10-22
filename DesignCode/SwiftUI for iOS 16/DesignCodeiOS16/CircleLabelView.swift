//
//  CircleLabelView.swift
//  DesignCodeiOS16
//
//  Created by MK on 10/22/24.
//

import SwiftUI

struct CircleLabelView: View {
	var text = "Latitude 35.08587 E • Longitude 21.43673 W • Elevation 64M • Incline 12 •".uppercased()
	var textWidth: Double = 4.9
	var diameter: Double = 300
	
    var body: some View {
		ZStack {
			ForEach(Array(text.enumerated()), id: \.offset) { index, letter in
				VStack {
					Text(String(letter))
					Spacer()
				}
				.rotationEffect(.degrees(textWidth * Double(index)))
			}
		}
		.frame(width: diameter, height: diameter)
		.font(.system(size: 13, design: .monospaced)).bold()
    }
}

#Preview {
    CircleLabelView()
}
