//
//  RippleView.swift
//  Notes
//
//  Created by Mk on 2/19/25.
//

import SwiftUI

struct RippleView: View {
	@State var counter: Int = 0
	@State var origin: CGPoint = .zero
	
	var body: some View {
		VStack {
			Spacer()
			
			Image("Sample_01")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.clipShape(RoundedRectangle(cornerRadius: 24))
				.onPressingChanged { point in
					if let point {
						origin = point
						counter += 1
					}
				}
				.modifier(RippleEffect(at: origin, trigger: counter))
			
			Spacer()
		}
		.padding()
	}
}

#Preview {
	RippleView()
}
