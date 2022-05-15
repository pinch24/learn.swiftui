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
				}) {
					content
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
	
	var content: some View {
		
		VStack {
			
			// More Content
			VStack {
				
				NavigationLink(destination: FAQView()) {
					MenuRow()
				}
				
				divider
				
				NavigationLink(destination: PackagesView()) {
					MenuRow(title: "SwiftUI Packages", leftIcon: "square.stack.3d.up.fill")
				}
				
				divider
				
				Link(destination: URL(string: "https://www.youtube.com/channel/UCTIhfOopxukTIRkbXJ3kN-g")!) {
					MenuRow(title: "YouTube Channel", leftIcon: "play.rectangle.fill", rightIcon: "link")
				}
			}
			.padding(16)
			.background(Color("Background 1"))
			.background(VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark))
			.overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.white, lineWidth: 1).blendMode(.overlay))
			.mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
			.padding(.top, 20)
			
			Text("Version 1.00")
				.foregroundColor(.white.opacity(0.7))
				.padding(.top, 20)
				.padding(.horizontal, 20)
				.padding(.bottom, 10)
				.font(.footnote)
		}
		.foregroundColor(.white)
		.padding(.top, 20)
		.padding(.horizontal, 20)
		.padding(.bottom, 10)
	}
	
	var divider: some View {
		
		Divider().background(Color.white.blendMode(.overlay))
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
