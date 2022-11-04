//
//  SeatsView.swift
//  MovieBooking
//
//  Created by mk on 2022/10/28.
//

import SwiftUI

struct SeatsView: View {
	@Environment(\.dismiss) var dismiss
	
    var body: some View {
		VStack(spacing: 0) {
			HStack {
				CircleButton(action: {
					dismiss()
				}, image: "arrow.left")
				
				Spacer()
				
				Text("Choose Seats")
					.font(.title3)
					.foregroundColor(.white)
					.fontWeight(.bold)
				
				Spacer()
				
				CircleButton(action: {}, image: "calendar")
			}
			.padding(.top, 46)
			.padding(.horizontal, 20)
			
			Image("frontSeat")
				.padding(.top, 55)
				.glow(color: Color("pink"), radius: 20)
			
			Image("seats")
				.frame(height: 240)
				.padding(.top, 60)
				.padding(.horizontal, 20)
			
			HStack(spacing: 2) {
				StatusUI()
				StatusUI(color: Color("magenta"), text: "Reserved")
				StatusUI(color: Color("cyan"), text: "Selected")
			}
			.padding(.top, 60)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.background(Color("backgroundColor"))
		.ignoresSafeArea()
		.navigationBarBackButtonHidden(true)
    }
}

struct SeatView_Previews: PreviewProvider {
    static var previews: some View {
        SeatsView()
    }
}
