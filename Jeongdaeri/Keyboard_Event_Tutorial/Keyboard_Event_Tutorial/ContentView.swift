//
//  ContentView.swift
//  Keyboard_Event_Tutorial
//
//  Created by mk on 2023/05/07.
//

import SwiftUI

struct ContentView: View {
	@State var nameInput: String = ""
	@State var emailInput: String = ""
	@State var passwordInput: String = ""
	@State var passwordConfirmInput: String = ""
	
	@ObservedObject var keyboardMonitor : KeyboardMonitor = KeyboardMonitor()
	@State var keyboardStatus: KeyboardMonitor.Status = .hide
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			VStack(alignment: .leading, spacing: 0) {
				Text("키보드 상태")
					.font(.title2)
				Divider()
					.colorMultiply(.clear)
					.padding(.vertical, 5)
				//Text(keyboardMonitor.updatedKeyboardStatusAction.description)
				Text(keyboardStatus.description)
				Text("키보드 높이: \(keyboardMonitor.updatedKeyboardFrameHeight)")
			}
			.padding()
			.background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
			.onReceive(self.keyboardMonitor.updatedKeyboardStatusAction, perform: { updatedStatus in
				self.keyboardStatus = updatedStatus
			})
			
			VStack(alignment: .leading) {
				Text("이름")
				TextField("이름을 입력해주세요", text: $nameInput)
					.keyboardType(.default)
					.autocapitalization(.none)
			}
			.padding()
			.background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
			
			VStack(alignment: .leading) {
				Text("이메일")
				TextField("이메일", text: $emailInput)
					.keyboardType(.emailAddress)
					.autocapitalization(.none)
			}
			.padding()
			.background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
			
			VStack(alignment: .leading) {
				Text("비밀번호")
				SecureField("비밀번호", text: $passwordInput)
					.keyboardType(.default)
				SecureField("비밀번호 확인", text: $passwordConfirmInput)
					.keyboardType(.default)
			}
			.padding()
			.background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
			
			Rectangle().fill(Color.red).frame(maxHeight: 300)
			
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: 10) {
					Text("주의사항")
					Text("찾아다녀도, 같은 인간의 끓는 방황하여도, 돋고, 뿐이다. 소금이라 구하지 몸이 얼음에 뜨거운지라, 튼튼하며, 그리하였는가? 가는 밥을 능히 영원히 대한 부패를 피어나는 이상의 오아이스도 칼이다. 그들의 끝까지 없는 과실이 광야에서 보라. 황금시대의 그들은 관현악이며, 없으면 것이다. 인생의 인생에 목숨이 보내는 끓는 있는 따뜻한 쓸쓸하랴? 싹이 청춘 싸인 철환하였는가? 꽃이 열락의 피는 것이다.보라, 피가 품에 지혜는 어디 약동하다. 용기가 이상의 천하를 가치를 트고, 않는 앞이 얼음과 황금시대다. 없으면, 않는 인생에 피고, 없는 이상, 피다.\n열락의 옷을 따뜻한 구하지 산야에 이상은 이 보라. 가치를 커다란 심장은 굳세게 오아이스도 힘차게 없으면, 못할 사라지지 황금시대다. 위하여, 이것이야말로 우리의 수 운다. 인간의 피부가 동력은 웅대한 바로 청춘의 얼음이 없으면 운다. 부패를 옷을 있을 밥을 예가 그들의 때문이다. 트고, 뜨거운지라, 자신과 온갖 가는 아니더면, 이상 돋고, 사는가 사막이다. 새가 싶이 피가 그것은 같지 같이, 웅대한 광야에서 아름다우냐? 능히 쓸쓸한 피어나는 크고 내려온 석가는 너의 아름다우냐? 때까지 무엇을 같이, 때문이다.\n곳이 오직 그것은 교향악이다. 인도하겠다는 사라지지 따뜻한 행복스럽고 가장 두기 천하를 맺어, 커다란 사막이다. 따뜻한 낙원을 용감하고 수 귀는 보이는 석가는 것이다. 방지하는 군영과 기쁘며, 따뜻한 꾸며 거친 그들의 있으랴? 보내는 아니더면, 이것은 피가 크고 가장 있는 있는가? 목숨을 황금시대의 뼈 보이는 착목한는 실로 이것은 옷을 쓸쓸하랴? 것이다.보라, 너의 타오르고 그러므로 바이며, 그것을 위하여, 피가 운다. 봄날의 황금시대의 생명을 물방아 인생을 하였으며, 천하를 돋고, 황금시대다. 이 피어나는 사람은 같이, 그리하였는가? 피가 갑 찬미를 천자만홍이 천하를 주는 피에 어디 넣는 듣는다.")
						.font(.caption)
				}
			}
			.frame(height: keyboardStatus == .show ? 300 : 0)
			
			GeometryReader { proxy in
				Button {
					print("회원가입 버튼 클릭")
				} label: {
					Text("회원가입하기")
						.foregroundColor(.black)
						.font(.title2)
						.frame(maxWidth: proxy.frame(in: .named("containerVStack")).width)
				}
				.padding()
				.background(RoundedRectangle(cornerRadius: 10).fill(.yellow))
			}
			.padding(.bottom, keyboardStatus == .show ? 50 : 0)
		}//VStack
		.background(Color.purple)
		.padding(.horizontal, 20)
		.coordinateSpace(name: "containerVStack")
		.navigationTitle("회원가입")
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
