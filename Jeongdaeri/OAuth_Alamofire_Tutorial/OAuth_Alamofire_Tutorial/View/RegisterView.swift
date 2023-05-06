//
//  RegisterView.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import SwiftUI

struct RegisterView: View {
	@State var nameInput: String = ""
	@State var emailInput: String = ""
	@State var passwordInput: String = ""
	
	var body: some View {
		VStack {
			Form {
				Section(header: Text("이름"), content: {
									
					TextField("이름", text: $nameInput)
						.keyboardType(.default)
				})
				
				Section(header: Text("이메일"), content: {
					
					TextField("이메일", text: $emailInput)
						.keyboardType(.emailAddress)
						.autocapitalization(.none)
						.autocorrectionDisabled()
				})
				
				Section(header: Text("비밀번호"), content: {
					
					SecureField("비밀번호", text: $passwordInput)
						.keyboardType(.default)
					
					SecureField("비밀번호 확인", text: $passwordInput)
						.keyboardType(.default)
				})
				
				Section {
					
					Button(action: {
						print("회원가입 버튼 터치")
					}, label: {
						Text("회원가입 하기")
					})
				}
			}
		}//Form
		.navigationTitle("회원가입")
	}
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
