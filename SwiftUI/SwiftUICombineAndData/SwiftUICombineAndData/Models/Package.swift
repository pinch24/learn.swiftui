//
//  Package.swift
//  SwiftUICombineAndData
//
//  Created by mk on 2022/05/22.
//

import Foundation

struct Package: Identifiable {
	
	var id = UUID()
	var title: String
	var link: String
}

let packagesData = [
	Package(title: "Firebase", link: "https://github.com/firebase/firebase-ios-sdk"),
	Package(title: "SDWebImageSwiftUI", link: "https://github.com/SDWebImage/SDWebImageSwiftUI"),
	Package(title: "SwiftUI", link: "https://github.com/maxnatchanon/trackable-scroll-view"),
	Package(title: "SwiftUIX", link: "https://github.com/SwiftUIX/SwiftUIX")
]
