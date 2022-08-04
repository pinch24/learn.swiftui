//
//  ModalView.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/08/04.
//

import SwiftUI

struct ModalView: View {
	@AppStorage("showModal") var showModal = true
	@EnvironmentObject var model: Model
	
    var body: some View {
		ZStack {
			Color.clear.background(.regularMaterial)
				.ignoresSafeArea()
			
			switch model.selectedModal {
				case .signIn:
					SignInView()
				case .signUp:
					SignUpView()
			}
			
			Button {
				withAnimation {
					showModal = false
				}
			} label: {
				Image(systemName: "xmark")
					.font(.body.weight(.semibold))
					.foregroundColor(.secondary)
					.padding(8)
					.background(.ultraThinMaterial, in: Circle())
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
			.padding(20)
		}
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
		ModalView()
			.environmentObject(Model())
    }
}
