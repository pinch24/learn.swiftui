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
	@State var viewState: CGSize = .zero
	
    var body: some View {
		ZStack {
			Color.clear.background(.regularMaterial)
				.ignoresSafeArea()
			
			Group {
				switch model.selectedModal {
					case .signIn:
						SignInView()
					case .signUp:
						SignUpView()
				}
			}
			.mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
			.offset(x: viewState.width, y: viewState.height)
			.rotationEffect(.degrees(viewState.width/40))
			.rotation3DEffect(.degrees(viewState.height/20), axis: (x: 1, y: 0, z: 0))
			.hueRotation(.degrees(viewState.width/5))
			.gesture(drag)
			.padding(20)
			.background(Image("Blob 1").offset(x: 200, y: -100))
			
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
	
	var drag: some Gesture {
		DragGesture()
			.onChanged { value in
				viewState = value.translation
			}
			.onEnded { value in
				withAnimation(.openCard) {
					viewState = .zero
				}
			}
	}
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
		ModalView()
			.environmentObject(Model())
    }
}
