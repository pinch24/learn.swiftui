//
//  NavigationStackView.swift
//  DesignCodeiOS16
//
//  Created by mk on 2023/01/01.
//

import SwiftUI

struct NavigationStackView: View {
    var body: some View {
		NavigationStack {
			List(0 ..< 5) { item in
				NavigationLink(destination: Text("Content")) {
					Label("Item", systemImage: "house")
						.foregroundColor(.primary)
				}
			}
			.navigationTitle("SwiftUI Apps")
			.navigationBarTitleDisplayMode(.inline)
			.listStyle(.plain)
		}
    }
}

struct NavigationStackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStackView()
    }
}
