//
//  Extensions.swift
//  AutoScrollingTabs
//
//  Created by Mk on 2/21/25.
//

import SwiftUI

extension [Product] {
	/// Return the Array's First Product Type
	var type: ProductType {
		if let firstProduct = self.first {
			return firstProduct.type
		}		
		return .iphone
	}
}

/// Scroll Content Offset
struct OffsetKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}

extension View {
	@ViewBuilder
	func offset(_ coordinateSpace: AnyHashable, completion: @escaping (CGRect) -> ()) -> some View {
		self
			.overlay {
				GeometryReader {
					let rect = $0.frame(in: .named(coordinateSpace))
					
					Color.clear
						.preference(key: OffsetKey.self, value: rect)
						.onPreferenceChange(OffsetKey.self, perform: completion)
				}
			}
	}
	
	@ViewBuilder
	func checkAnimationEnd<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> ()) -> some View {
		self
			.modifier(AnimationEndCallback(for: value, onEnd: completion))
	}
}

/// Animation OnEnd CallBack
fileprivate struct AnimationEndCallback<Value: VectorArithmetic>: Animatable, ViewModifier {
	var animatableData: Value {
		didSet {
			
		}
	}
	
	var endValue: Value
	var onEnd: () -> ()
	
	init(for value: Value, onEnd: @escaping () -> Void) {
		self.animatableData = value
		self.endValue = value
		self.onEnd = onEnd
	}
	
	func body(content: Content) -> some View {
		content
	}
	
	private func checkIfFinished() {
		if endValue == animatableData {
			DispatchQueue.main.async {
				onEnd()
			}
		}
	}
}
