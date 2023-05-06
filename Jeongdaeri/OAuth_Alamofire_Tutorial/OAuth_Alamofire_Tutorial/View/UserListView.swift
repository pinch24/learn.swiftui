//
//  UserListView.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import SwiftUI

struct UserListView: View {
	@EnvironmentObject var userViewModel: UserViewModel
	
	@State var users: [UserData] = []
	
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
				}//HStack
			})
		}//List
		.navigationTitle("사용자 목록")
		.onAppear(perform: { userViewModel.fetchUsers() })
		.onReceive(userViewModel.$users, perform: { self.users = $0 })
	}
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
			.environmentObject(UserViewModel())
    }
}
