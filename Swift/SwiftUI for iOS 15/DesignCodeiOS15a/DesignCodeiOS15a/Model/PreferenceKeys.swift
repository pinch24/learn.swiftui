//
//  PreferenceKeys.swift
//  DesignCodeiOS15a
//
//  Created by mk on 2022/07/14.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}
