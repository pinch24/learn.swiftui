//
//  ProfileView.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import SwiftUI

struct ProfileView: View {
	@State var id: String = ""
	@State var name: String = ""
	@State var email: String = ""
	@State var avatarImage: String = ""
	
	var body: some View {
		VStack {
			Form {
				Section {
					HStack {
						Spacer()
						if avatarImage.isEmpty {
							Image(systemName: "person.fill.questionmark")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.padding()
								.frame(width: 250, height: 250, alignment: .center)
						}
						else {
							AsyncImage(url: URL(string: avatarImage)) { phase in
								switch phase {
									case .empty:
										ProgressView()
											.frame(width: 250, height: 250, alignment: .center)
									case .success(let image):
										image
											.resizable()
											.aspectRatio(contentMode: .fit)
											.frame(width: 250, height: 250, alignment: .center)
									case .failure:
										Image(systemName: "person.fill.questionmark")
											.resizable()
											.aspectRatio(contentMode: .fit)
											.padding()
											.frame(width: 250, height: 250, alignment: .center)
										
									@unknown default:
										EmptyView()
								}
							}
						}
						Spacer()
					}//HStack
				}//Section
				Section {
					Text("아이디: \(id)")
					Text("이름: \(name)")
					Text("이메일: \(email)")
				}//Section
				Section {
					Button(action: {
						print("새로고침 버튼 클릭")
					}, label: {
						Text("새로고침")
					})
				}//Section
			}//Form
		}
		.navigationTitle("로그인 하기")
	}
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
