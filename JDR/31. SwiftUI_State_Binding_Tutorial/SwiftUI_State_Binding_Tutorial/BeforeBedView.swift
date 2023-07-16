//
//  BeforeBedView.swift
//  SwiftUI_State_Binding_Tutorial
//
//  Created by mk on 2023/05/03.
//

import SwiftUI

struct BeforeBedView: View {
	@EnvironmentObject var viewModel : MyViewModel
	
	@Binding var count : Int
	
	@State var title : String = ""
	
    var body: some View {
		VStack {
			Text(title)
				.font(.system(size: 26))
				.fontWeight(.bold)
				.padding()
			Text("자기전에 빡코딩! count: \(count)")
				.padding()
			Button(action: {
				count = count + 1
			}, label: {
				Text("카운트 업")
					.foregroundColor(.white)
					.padding()
					.background(Color.green)
					.cornerRadius(10.0)
			})
		}
		.onReceive(viewModel.$appTitle) { receivedAppTitle in
			print("BeforeBedView - receivedAppTitle: ", receivedAppTitle)
			title = receivedAppTitle
		}
    }
}

struct BeforeBedView_Previews: PreviewProvider {
    static var previews: some View {
		BeforeBedView(count: .constant(2))
			.environmentObject(MyViewModel())
    }
}
