//
//  AccountView.swift.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/06.
//

import SwiftUI

struct AccountView_swift: View {
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

struct AccountView_swift_Previews: PreviewProvider {
    static var previews: some View {
        AccountView_swift()
    }
}
