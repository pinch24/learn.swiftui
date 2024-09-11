//
//  CounterView.swift
//  Pointfree-065-SwiftUI-State-1
//
//  Created by MK on 3/5/24.
//

import SwiftUI

struct CounterView: View {
	@ObservedObject var state: AppState
	
    var body: some View {
		VStack {
			HStack {
				Button(action: { state.count -= 1 }) {
					Text("-")
				}
				Text("\(state.count)")
				Button(action: { state.count += 1 }) {
					Text("+")
				}
			}
			Button(action: {}) {
				Text("Is this prime?")
			}
			Button(action: {}) {
				Text("What's the \(ordinal(state.count)) prime?")
			}
		}
		.navigationBarTitle("Counter demo")
    }
	
	private func ordinal(_ n: Int) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .ordinal
		return formatter.string(for: n) ?? ""
	}
}

#Preview {
	CounterView(state: AppState())
}
