//
//  HomeView.swift
//  MovieBooking
//
//  Created by mk on 2022/10/14.
//

import SwiftUI

struct HomeView: View {
	@State var animate = false
	
    var body: some View {
		ZStack {
			CircleBackground(color: Color("greenCircle"))
				.blur(radius: animate ? 30 : 100)
				.offset(x: animate ? -50 : -130, y: animate ? -30 : -100)
				.task {
					withAnimation(.easeInOut(duration: 7).repeatForever(), {
						animate.toggle()
					})
				}
			
			VStack(spacing: 0) {
				Text("Choose Movie")
					.fontWeight(.bold)
					.font(.title3)
					.foregroundColor(.white)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			
			CustomSearchBar()
				.padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20))
		}
		.background(LinearGradient(colors: [Color("backgroundColor"), Color("backgroundColor2")], startPoint: .top, endPoint: .bottom))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
