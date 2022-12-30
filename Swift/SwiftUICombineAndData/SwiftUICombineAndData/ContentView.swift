//
//  ContentView.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/04/04.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	@State private var contentOffset = CGFloat.zero
	@State private var showCertificates: Bool = false
	
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
		.accentColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)))
    }
	
	var content: some View {
		VStack {
			ProfileRow()
				.onTapGesture {
					showCertificates.toggle()
				}
			
			VStack {
				NotificationRow()
				
				divider
				
				LiteModeRow()
			}
			.blurBackground()
			.padding(.top, 20)
			
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
			.blurBackground()
			.padding(.top, 20)
			
			Text("Version 1.01")
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
		.sheet(isPresented: $showCertificates) {
			CertificatesView()
		}
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
