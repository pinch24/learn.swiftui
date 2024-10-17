//
//  DrinkView.swift
//  SwiftUICombine
//
//  Created by MK on 10/16/24.
//

import SwiftUI

struct DrinkView: View {
	@ObservedObject var drinkModel = DrinkModel()
	
	var body: some View {
		VStack {
			Text("Number of glasses: \(drinkModel.numberOfGlasses)")
			Button {
				drinkModel.numberOfGlasses += 1
			} label: {
				Text("Add a glass")
					.padding()
					.background(.cyan)
					.clipShape(.rect(cornerRadius: 10))
			}
		}
	}
}

class DrinkModel: ObservableObject {
	@Published var numberOfGlasses: Int = 0
}

#Preview {
	DrinkView()
}
