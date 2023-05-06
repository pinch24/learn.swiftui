//
//  LoginView.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import SwiftUI

struct LoginView: View {
	
	@State var emailInput: String = ""
	@State var passwordInput: String = ""
	
    var body: some View {
		
		VStack {
			
			Form {
				
				Section(header: Text("로그인 정보"), content: {
					
					TextField("이메일", text: $emailInput)
						.keyboardType(.emailAddress)
						.autocapitalization(.none)
						.autocorrectionDisabled()
					
					SecureField("비밀번호", text: $passwordInput)
						.keyboardType(.default)
					
				})
				
				Section {
					
					Button(action: {
						print("로그인 버튼 터치")
					}, label: {
						Text("로그인 하기")
					})
				}
			}//Form
		}//VStack
		.navigationTitle("로그인 하기")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
