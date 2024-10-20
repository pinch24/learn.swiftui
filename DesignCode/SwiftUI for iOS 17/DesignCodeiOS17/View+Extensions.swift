//
//  View+Extensions.swift
//  DesignCodeiOS17
//
//  Created by MK on 10/20/24.
//

import SwiftUI

extension View {
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, @ViewBuilder transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}
