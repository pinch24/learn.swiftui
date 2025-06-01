//
//  GridView.swift
//  TCAWorks
//
//  Created by MK on 5/31/25.
//

import SwiftUI

struct GridView: View {
	@State private var isOn = false
	var body: some View {
		VStack(alignment: .leading) {
			Grid(alignment: .leading) {
				GridRow {
					Text("A")
						.padding()
						.border(Color.gray, width: 0.4)
					Text("B")
						.padding()
						.border(Color.gray, width: 0.4)
					Text("C")
						.padding()
						.border(Color.gray, width: 0.4)
					Text("D")
						.padding()
						.border(Color.gray, width: 0.4)
				}
				GridRow {
					Text("A1")
						.padding()
						.border(Color.gray, width: 0.4)
					Text("A2")
						.padding()
						.border(Color.gray, width: 0.4)
					Text("A3")
						.padding()
						.border(Color.gray, width: 0.4)
					Text("A4")
						.padding()
						.border(Color.gray, width: 0.4)
				}
				GridRow {
					Text("B1")
						.padding()
						.border(Color.gray, width: 0.4)
					Toggle("B2", isOn: $isOn)
						.frame(width: 80)
						.padding()
						.border(Color.gray, width: 0.4)
						.gridCellColumns(isOn ? 2 : 1)
					if isOn == false {
						Text("B3")
							.padding()
							.border(Color.gray, width: 0.4)
					}
					Text("B4")
				}
				GridRow {
					Text("C1")
						.padding()
						.border(Color.gray, width: 0.4)
					Text("C2")
						.padding()
						.border(Color.gray, width: 0.4)
					Text("C3")
						.padding()
						.border(Color.gray, width: 0.4)
					Text("C4")
						.padding()
						.border(Color.gray, width: 0.4)
				}
			}
			.border(Color.gray, width: 0.4)
			
			SpannableGridView()
				.border(Color.gray, width: 0.4)
			
//            if #available(iOS 16.0, *) {
//                Text("iOS 16+ Grid API")
//                    .font(.headline)
//
//                ModernSpannableGrid()
//            }
		}
	}
}

struct SpannableGridView: View {
	let columns = Array(repeating: GridItem(.flexible()), count: 3)
	var body: some View {
		LazyVGrid(columns: columns, spacing: 1) {
			// 첫 번째 줄
			Text("A")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.blue.opacity(0.3))
			
			Text("B")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.green.opacity(0.3))
			
			Text("C")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.red.opacity(0.3))
			
			// 두 번째 줄 - ColSpan 구현
			GeometryReader { geometry in
				HStack(spacing: 1) {
					Text("Span 2 Columns")
						.frame(width: (geometry.size.width * 2/3) - 0.5)
						.background(Color.orange.opacity(0.3))
					
					Text("E")
						.frame(width: geometry.size.width * 1/3 - 0.5)
						.background(Color.purple.opacity(0.3))
				}
			}
			.gridCellColumns(2) // iOS 16+
			
			// 세 번째 줄
			Text("F")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.cyan.opacity(0.3))
			
			Text("G")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.yellow.opacity(0.3))
			
			Text("H")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.pink.opacity(0.3))
		}
		.padding()
	}
}

#Preview {
	GridView()
}
