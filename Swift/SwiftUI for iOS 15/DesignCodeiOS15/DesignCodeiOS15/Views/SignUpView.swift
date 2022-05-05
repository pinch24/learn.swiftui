//
//  SignUpView.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/05/04.
//

import SwiftUI

struct SignUpView: View {
	
    var body: some View {
		
		VStack(alignment: .leading, spacing: 16) {
			
			Text("Sign up")
				.font(.largeTitle.bold())
			
			Text("Access 120+ hours of courses, tutorials and livestreams")
				.font(.headline)
			
			Button {
				
			} label: {
				
				Text("Create an account")
					.frame(maxWidth: .infinity)
			}
			.font(.headline)
			.blendMode(.overlay)
			.buttonStyle(.angular)
			.tint(.accentColor)
			.controlSize(.large)
			
			Group {
				Text("By clicking on ")
				+ Text("_Create an account_")
					.foregroundColor(.primary.opacity(0.7))
				+ Text(", you agree to our **Terms of Service** and **[Privacy Policy](https://designcode.io)**")
				
				Divider()
				
				HStack {
					Text("Already have an account?")
					Button {
						
					} label: {
						Text("**Sign in**")
					}
				}
			}
			.font(.footnote)
			.foregroundColor(.secondary)
			.accentColor(.secondary)
		}
		.padding(20)
		.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
		.strokeStyle(cornerRadius: 30)
		.shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
		.padding(20)
		.background(Image("Blob 1").offset(x: 200, y: -100))
    }
}

struct SignUpView_Previews: PreviewProvider {
	
    static var previews: some View {
		
		SignUpView()
			.preferredColorScheme(.light)
    }
}
