//
//  OtherUserProfileView.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import SwiftUI

struct OtherUserProfileView: View {
	@State var userData: UserData
	
	var body: some View {
		VStack {
			Form {
				Section {
					HStack {
						Spacer()
						AsyncImage(url: URL(string: userData.avatar)) { phase in
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
						Spacer()
					}//HStack
				}//Section
				Section(header: Text("아이디").font(.callout)) {
					Text("아이디: \(userData.id)")
				}
				Section(header: Text("이름").font(.callout)) {
					Text("이름: \(userData.name)")
				}
				Section(header: Text("이메일").font(.callout)) {
					Text("이메일: \(userData.email)")
				}
			}//Form
		}//VStack
		.navigationTitle(userData.name)
	}
}

struct OtherUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OtherUserProfileView(userData: UserData(id: 0, name: "Killy", email: "killy@blame.me", avatar: "https://static.wikia.nocookie.net/blame/images/2/29/Killy1.png/revision/latest?cb=20190619192420"))
    }
}
