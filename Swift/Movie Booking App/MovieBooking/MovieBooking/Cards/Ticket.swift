//
//  Ticket.swift
//  MovieBooking
//
//  Created by mk on 2022/10/06.
//

import SwiftUI

struct Ticket: View {
	@State var title = "Thor"
	@State var subtitle = "Love and Thunder"
	@State var top = "thor-top"
	
	var gradient = [Color("cyan"), Color("cyan").opacity(0), Color("cyan").opacity(0)]
	
    var body: some View {
		VStack(spacing: 0) {
			VStack(spacing: 4) {
				Text(title)
					.fontWeight(.bold)
				
				Text(subtitle)
			}
			.padding(EdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30))
			.frame(width: 250, height: 325, alignment: .top)
			.foregroundColor(.white)
			.background(
				Image(top)
					.resizable()
					.aspectRatio(contentMode: .fill)
			)
			.mask(
				Image(top)
					.resizable()
					.aspectRatio(contentMode: .fill)
			)
			.overlay(
				RoundedRectangle(cornerRadius: 40)
					.stroke(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 2))
			)
			.cornerRadius(40, corners: [.topLeft, .topRight])
		}
		.frame(height: 460)
		.font(.footnote)
		.shadow(radius: 10)
    }
}

struct Ticket_Previews: PreviewProvider {
    static var previews: some View {
        Ticket()
    }
}
