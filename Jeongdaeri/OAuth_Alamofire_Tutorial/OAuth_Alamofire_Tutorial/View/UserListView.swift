//
//  UserListView.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import SwiftUI

struct UserListView: View {
	@State var users: [UserData] = [
		UserData(id: 0, name: "AAA", email: "aaa@bbb.ccc", avatar: "https://static.wikia.nocookie.net/blame/images/2/29/Killy1.png/revision/latest?cb=20190619192420"),
		UserData(id: 0, name: "AAA", email: "aaa@bbb.ccc", avatar: "https://static.wikia.nocookie.net/blame/images/2/29/Killy1.png/revision/latest?cb=20190619192420"),
		UserData(id: 0, name: "AAA", email: "aaa@bbb.ccc", avatar: "https://static.wikia.nocookie.net/blame/images/2/29/Killy1.png/revision/latest?cb=20190619192420"),
	]
	
	var body: some View {
		List(users) { aUser in
			NavigationLink(destination: OtherUserProfileView(userData: aUser), label: {
				HStack {
					AsyncImage(url: URL(string: aUser.avatar)) { phase in
						switch phase {
							case .empty:
								ProgressView()
									.frame(width: 120, height: 120, alignment: .center)
							case .success(let image):
								image
									.resizable()
									.aspectRatio(contentMode: .fit)
									.frame(width: 120, height: 120, alignment: .center)
							case .failure:
								Image(systemName: "person.fill.questionmark")
									.resizable()
									.aspectRatio(contentMode: .fit)
									.padding()
									.frame(width: 120, height: 120, alignment: .center)
								
							@unknown default:
								EmptyView()
						}
					}
					Spacer()
					VStack(alignment: .leading) {
						Text(aUser.name)
							.font(.title3)
						Text(aUser.email)
							.font(.callout)
					}
				}
			})
		}
		.navigationTitle("사용자 목록")
	}
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
