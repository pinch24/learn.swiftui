//
//  AccountView.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/04/10.
//

import SwiftUI

struct AccountView: View {
	
    var body: some View {
		
		NavigationView {
			
			 List {
				 
				 Section {
					 
					 Text("Settings")
					 Text("Billing")
					 Text("Help")
				 } 
				 .listRowSeparatorTint(.blue)
				 .listRowSeparator(.hidden)
			}
			.listStyle(.insetGrouped)
			.navigationTitle("Account")
		}
    }
}

struct AccountView_Previews: PreviewProvider {
	
    static var previews: some View {
		
        AccountView()
    }
}
