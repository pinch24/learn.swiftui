//
//  Color+Extension.swift
//  RGBullsEye
//
//  Created by mk on 12/10/23.
//

import SwiftUI

extension Color {
	init(rgbStruct rgb: RGB) {
		self.init(red: rgb.red, green: rgb.green, blue: rgb.blue)
	}
}
