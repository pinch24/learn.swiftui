//
//  Tickets.swift
//  MovieBooking
//
//  Created by mk on 2022/10/06.
//

import SwiftUI

struct Tickets: View {
	@State var tickets: [TicketModel] = [
		TicketModel(image: "thor", title: "Thor", subtitle: "Love and Thunder", top: "thor-top", bottom: "thor-bottom"),
		TicketModel(image: "panther", title: "Black Panther", subtitle: "Wakanda Forever", top: "panther-top", bottom: "panther-bottom"),
		TicketModel(image: "scarlet", title: "Doctor Strange", subtitle: "in the Multiverse of Madness", top: "scarlet-top", bottom: "scarlet-bottom")
	]
	
    var body: some View {
		ZStack {
			ForEach(tickets) { ticket in
				InfiniteStackView(tickets: $tickets, ticket: ticket)
			}
		}
		.padding()
		.frame(width: .infinity, height: .infinity, alignment: .center)
    }
}

struct Tickets_Previews: PreviewProvider {
    static var previews: some View {
        Tickets()
    }
}

struct InfiniteStackView: View {
	@Binding var tickets: [TicketModel]
	var ticket: TicketModel
	
	@GestureState var isDragging: Bool = false
	@State var offset: CGFloat = .zero
	
	@State var height: CGFloat = 0
	
	var body: some View {
		VStack {
			Ticket(height: $height, title: ticket.title, subtitle: ticket.subtitle, top: ticket.top, bottom: ticket.bottom)
		}
		.frame(width: .infinity, height: .infinity)
		.zIndex(Double(CGFloat(tickets.count) - getIndex()))
		.rotationEffect(getIndex() == 1 ? .degrees(-6) : .degrees(0))
		.rotationEffect(getIndex() == 2 ? .degrees(6) : .degrees(0))
		.scaleEffect(getIndex() == 0 ? 1 : 0.9)
		.offset(x: getIndex() == 1 ? -40 : 0)
		.offset(x: getIndex() == 2 ? 40 : 0)
		.offset(x: offset)
		.gesture(
			DragGesture()
				.updating($isDragging, body: { _, out, _ in
					out = true
				})
				.onChanged({ value in
					var translation = value.translation.width
					translation = tickets.first?.id == ticket.id ? translation : 0
					translation = isDragging ? translation : 0
					
					withAnimation(.easeInOut(duration: 0.3)) {
						offset = translation
					}
				})
				.onEnded({ value in
					withAnimation(.easeInOut(duration: 0.5)) {
						offset = .zero
					}
				})
		)
	}
	
	func getIndex() -> CGFloat {
		let index = tickets.firstIndex { ticket in
			return self.ticket.id == ticket.id
		} ?? 0
		
		return CGFloat(index)
	}
}
