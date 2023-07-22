//
//  CardReflectionView.swift
//  DesignCodeiOS16
//
//  Created by mk on 2023/07/23.
//

import SwiftUI

struct CardReflectionView: View {
    var body: some View {
		ZStack {
			Color("Background")
				.ignoresSafeArea()
			
			Image("Background 1")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(height: 600)
				.overlay(
					ZStack {
						Image("Logo 1")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 180)
						Image("Logo 2")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 400)
						Image("Logo 3")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 392, height: 600)
							.blendMode(.overlay)
					}
				)
				.cornerRadius(50)
				.scaleEffect(0.9)
		}
		.preferredColorScheme(.dark)
    }
}

struct CardReflectionView_Previews: PreviewProvider {
    static var previews: some View {
        CardReflectionView()
    }
}
