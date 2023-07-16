//
//  ContentView.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/05.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var testViewModel: TestViewModel = TestViewModel()
	
	@State fileprivate var isLoading: Bool = false
	@State fileprivate var isRequestTimeout: Bool = false
	
    var body: some View {
		ZStack {
			NavigationView {
				VStack(spacing: 0) {
					Image(systemName: "lock.shield.fill")
						.font(.system(size: 160))
					
					Spacer()
					
					NavigationLink(destination: LoginView(), label: {
						HStack {
							Spacer()
							Text("로그인 하러가기")
							Spacer()
						}
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.clipShape(RoundedRectangle(cornerRadius: 6))
					})
					.padding([.bottom], 10)
					
					NavigationLink(destination: RegisterView(), label: {
						HStack {
							Spacer()
							Text("회원가입 하러가기")
							Spacer()
						}
						.padding()
						.background(Color.black)
						.foregroundColor(.white)
						.clipShape(RoundedRectangle(cornerRadius: 6))
					})
					
					Spacer().frame(height: 40)
					
					NavigationLink(destination: ProfileView(), label: {
						HStack {
							Spacer()
							Text("내 프로필 보러가기")
							Spacer()
						}
						.padding()
						.background(Color.purple)
						.foregroundColor(.white)
						.clipShape(RoundedRectangle(cornerRadius: 6))
					})
					.padding([.bottom], 10)
					
					NavigationLink(destination: UserListView(), label: {
						HStack {
							Spacer()
							Text("사용자 목록 보러가기")
							Spacer()
						}
						.padding()
						.background(Color.green)
						.foregroundColor(.white)
						.clipShape(RoundedRectangle(cornerRadius: 6))
					})
					
					Spacer()
					
					Button(action: {
						withAnimation {
							self.isLoading = true
						}
						self.testViewModel.requestTimeoutTest()
					}, label: {
						Text("리퀘스트 타임아웃 API 테스트")
					})
					.padding()
					.background(Color.green)
					.foregroundColor(.white)
					.clipShape(RoundedRectangle(cornerRadius: 6))
					
					Spacer()
				}//VStack
				.padding()
			}// Navigation
			
			if isLoading {
				Color.black
					.opacity(0.7)
					.ignoresSafeArea()
				
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle(tint: .white))
					.scaleEffect(2)
			}
		}//ZStack
		.alert(isPresented: $isRequestTimeout, content: {
			Alert(title: Text("리퀘스트 타임아웃"), message: Text(""), dismissButton: .default(Text("닫기")))
		})
		.onReceive(self.testViewModel.timeoutEvent, perform: { _ in
			withAnimation {
				self.isLoading = false
			}
			self.isRequestTimeout = true
		})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(UserViewModel())
    }
}
