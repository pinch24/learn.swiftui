//
//  ContentView.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/04/04.
//

import SwiftUI

struct ContentView: View {
	
	@State private var contentOffset = CGFloat.zero
	
    var body: some View {
		
		NavigationView {
			
			ZStack(alignment: .top) {
				
				TrackableScrollView(offsetChanged: { offset in
					
					contentOffset = offset.y
					print("contentOffset", contentOffset)
				}) {
					
					Text("Hello, world!")
						.padding()
				}
				
				VisualEffectBlur(blurStyle: .systemMaterial)
					.opacity(contentOffset < -16 ? 1: 0)
					.animation(.easeIn, value: 8)
					.ignoresSafeArea()
					.frame(height: 0)
				
			}
			.frame(maxHeight: .infinity, alignment: .top)
			.background(AccountBackground())
			.navigationBarHidden(true)
		}
		.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
