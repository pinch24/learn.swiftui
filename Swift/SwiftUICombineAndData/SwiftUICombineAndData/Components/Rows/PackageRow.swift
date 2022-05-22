//
//  PackageRow.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/05/22.
//

import SwiftUI

struct PackageRow: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	var package: Package
	
	
    var body: some View {
		
		VStack(alignment: .leading) {
			Link(destination: URL(string: package.link)!) {
				LinearGradient(gradient: Gradient(colors: colorScheme == .dark ? [Color(#colorLiteral(red: 0.6808851361, green: 0.7434214354, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.654221952, blue: 0.9848131537, alpha: 1))] : [Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
					.frame(height: 20)
					.mask(
						Text(package.title)
							.font(.subheadline)
							.fontWeight(.medium)
							.textCase(.uppercase)
							.frame(maxWidth: .infinity, alignment: .leading)
					)
			}
			
			Divider()
		}
    }
}

struct PackageRow_Previews: PreviewProvider {
    static var previews: some View {
        PackageRow(package: packagesData[0])
			.environment(\.colorScheme, .dark)
    }
}
