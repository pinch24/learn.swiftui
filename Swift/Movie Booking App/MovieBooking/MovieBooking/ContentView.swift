//
//  ContentView.swift
//  MovieBooking
//
//  Created by mk on 2022/10/06.
//

import SwiftUI

struct ContentView: View {
	@State var animate = false
		
    var body: some View {
		ZStack {
			TicketView()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
