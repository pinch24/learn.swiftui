//
//  View+Extension.swift
//  OAuth_Alamofire_Tutorial
//
//  Created by mk on 2023/05/06.
//

import SwiftUI

extension View {
	
	func placeholder<T: View>(shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder placeholderText: () -> T) -> some View {
		ZStack(alignment: alignment) {
			placeholderText()
				.opacity(shouldShow ? 1: 0)
			
			self
		}
	}
}
