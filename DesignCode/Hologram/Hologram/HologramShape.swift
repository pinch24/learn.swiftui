//
//  HologramShape.swift
//  Hologram
//
//  Created by MK on 10/24/24.
//

import SwiftUI

struct HologramShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		let patternSize: CGFloat = 20
		let rowCount = Int(rect.height / patternSize) + 1
		let columnCount = Int(rect.width / patternSize) + 1
		
		for row in 0..<rowCount {
			for column in 0..<columnCount {
				let x = CGFloat(column) * patternSize
				let y = CGFloat(row) * patternSize
				let circle = Path(ellipseIn: CGRect(x: x, y: y, width: patternSize, height: patternSize))
				path.addPath(circle)
			}
		}
		
		return path
	}
}
