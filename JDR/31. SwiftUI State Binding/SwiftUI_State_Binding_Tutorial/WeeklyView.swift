//
//  WeeklyView.swift
//  SwiftUI_State_Binding_Tutorial
//
//  Created by mk on 2023/05/03.
//

import SwiftUI

struct WeeklyView: View {
	@EnvironmentObject var viewModel : MyViewModel
	
	@Binding var count : Int
	
	init(count: Binding<Int> = .constant(99)) {
		_count = count
	}
	
	@State var title : String = ""
		
	var body: some View {
		VStack {
			Text(title)
				.font(.system(size: 26))
				.fontWeight(.bold)
				.padding()
			Text("주말에도 빡코딩! count: \(count)")
				.padding()
			Button(action: {
				count = count + 1
			}, label: {
				Text("카운트 업")
					.foregroundColor(.white)
					.padding()
					.background(Color.orange)
					.cornerRadius(10.0)
			})
		}
		.onReceive(viewModel.$appTitle) { receivedAppTitle in
			print("BeforeBedView - receivedAppTitle: ", receivedAppTitle)
			title = receivedAppTitle
		}
	}
}

struct WeeklyView_Previews: PreviewProvider {
    static var previews: some View {
		WeeklyView(count: .constant(2))
			.environmentObject(MyViewModel())
    }
}
