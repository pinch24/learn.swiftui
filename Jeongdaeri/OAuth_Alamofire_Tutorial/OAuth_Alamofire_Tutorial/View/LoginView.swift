//
//  LoginView.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import SwiftUI

struct LoginView: View {
	@Environment(\.dismiss) var dismiss
		
	@EnvironmentObject var userViewModel: UserViewModel
		
	@State fileprivate var shouldShowAlert: Bool = false
	
	@State var emailInput: String = "test_03@email.com"
	@State var passwordInput: String = "11112222"
	
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
						userViewModel.login(email: emailInput, password: passwordInput)
					}, label: {
						Text("로그인 하기")
					})
				}
			}//Form
			.onReceive(userViewModel.loginSuccess, perform: {
				print("LoginView - loginSuccess() called")
				self.shouldShowAlert = true
			})
			.alert("로그인이 완료되었습니다.", isPresented: $shouldShowAlert) {
				Button("확인", role: .cancel) {
					self.dismiss()
				}
			}
		}//VStack
		.navigationTitle("로그인 하기")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
