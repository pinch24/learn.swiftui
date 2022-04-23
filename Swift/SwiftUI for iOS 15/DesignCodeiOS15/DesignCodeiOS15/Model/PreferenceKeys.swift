//
//  PreferenceKeys.swift
//  DesignCodeiOS15
//
//  Created by mk on 2022/04/23.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
	
	static var defaultValue: CGFloat = 0
	
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}
