//
//  ContentView.swift
//  AnimatedKeyPad
//
//  Created by Mk on 2/20/25.
//

import SwiftUI

struct ContentView: View {
	@State private var value: KeyPadValue = .init()
	@Namespace private var animation
	
    var body: some View {
		VStack(spacing: 20) {
			Text("Spend Money")
				.font(.largeTitle.bold())
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.leading, 5)
			
			VStack(spacing: 6) {
				Image(.pic)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 100, height: 100)
					.clipShape(.circle)
				
				Text("Claire Blakewood")
					.font(.caption)
					.fontWeight(.semibold)
			}
			.frame(maxHeight: .infinity)
			
			/// Animated Text View
			AnimatedTextView()
				.font(.largeTitle.bold())
				.frame(height: 50)
				.padding(.bottom, 30)
			
			/// Custom Keypad View
			CustomKeypad()
        }
		.fontDesign(.rounded)
		.padding(15)
		.preferredColorScheme(.dark)
    }
	
	@ViewBuilder
	func AnimatedTextView() -> some View {
		HStack(spacing: 2) {
			Text("$")
			
			Text(value.isEmpty ? "0" : "")
				.frame(width: value.isEmpty ? nil : 0)
				.contentTransition(.numericText())
				.padding(.leading, 3)
			
			ForEach(value.stackViews) { number in
				Group {
					if number.isComma {
						Text(",")
							.contentTransition(.interpolate)
							.matchedGeometryEffect(id: number.commaID, in: animation)
					}
					else {
						Text(number.value)
							.contentTransition(.interpolate)
							.transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
					}
				}
			}
		}
	}
	
	@ViewBuilder
	func CustomKeypad() -> some View {
		LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
			/// 1-9 Buttons
			ForEach(1...9, id: \.self) { index in
				Button {
					withAnimation(.easeInOut(duration: 0.25)) {
						value.append(index)
					}
				} label: {
					Text("\(index)")
						.font(.title2.bold())
						.frame(maxWidth: .infinity)
						.frame(height: 70)
						.contentShape(.rect)
				}
			}
			
			Spacer()
			
			/// 0 & Back Button
			ForEach(["0", "delete.backward.fill"], id: \.self) { string in
				Button {
					withAnimation(.easeInOut(duration: 0.25)) {
						if string == "0" {
							value.append(0)
						}
						else {
							value.removeLast()
						}
					}
				} label: {
					Group {
						if string == "0" {
							Text("0")
						}
						else {
							Image(systemName: string)
						}
					}
					.font(.title2.bold())
					.frame(maxWidth: .infinity)
					.frame(height: 70)
					.contentShape(.rect)
				}
				
				/// Repeating behavior for back button to erase all digits if long pressed!
				.buttonRepeatBehavior(string == "0" ? .disabled : .enabled)
			}
		}
		.buttonStyle(KeypadButtonStyle())
		.foregroundStyle(.white)
	}
}

struct KeypadButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.background {
				RoundedRectangle(cornerRadius: 15)
					.fill(.gray.opacity(0.2))
					.opacity(configuration.isPressed ? 1 : 0)
					.padding(.horizontal, 5)
			}
			.animation(.easeInOut(duration: 0.25), value: configuration.isPressed)
	}
}

struct KeyPadValue {
	var stringValue: String = ""
	var stackViews: [Number] = []
	
	struct Number: Identifiable {
		var id: Int = UUID().hashValue
		var value: String = ""
		var isComma: Bool = false
		/// Used for matched geometry effect
		var commaID: Int = 0
	}
	
	mutating func append(_ number: Int) {
		/// Limiting the maximum length and avoiding adding a zero as the first value
		guard !isExceedingMaxLength && (number == 0 ? !stringValue.isEmpty : true) else { return }
		
		stringValue.append(String(number))
		stackViews.append(.init(value: String(number)))
		
		updateCommas()
	}
	
	mutating func removeLast() {
		guard !stringValue.isEmpty else { return }
		
		stringValue.removeLast()
		stackViews.removeLast()
		
		updateCommas()
	}
	
	mutating func updateCommas() {
		guard let number = Int(.init(stringValue)) else { return }
		
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.locale = Locale(identifier: localFormat)
		
		if let formattedNumber = formatter.string(from: .init(value: number)) {
			/// Removing Previous Commas
			stackViews.removeAll(where: \.isComma)
			
			let stackWithCommas = formattedNumber.compactMap {
				let value = String($0)
				return Number(value: value, isComma: value == ",")
			}
			
			let onlyCommaArray = stackWithCommas.filter(\.isComma)
			
			/// Adding Commas to actual stack view without modifying other stack view ids
			for index in stackWithCommas.indices {
				let number = stackWithCommas[index]
				let commaIndex = onlyCommaArray.firstIndex(where: { $0.id == number.id }) ?? 0
				
				if number.isComma {
					stackViews.insert(.init(value: ",", isComma: true, commaID: commaIndex), at: index)
				}
			}
		}
	}
	
	/// Other Computed Properties
	var isEmpty: Bool {
		stringValue.isEmpty
	}
	
	var isExceedingMaxLength: Bool {
		/// Im only setting the max length to 9, but you can change this as per your needs!
		stringValue.count >= 9
	}
	
	var intValue: Int {
		Int(stringValue) ?? 0
	}
	
	var localFormat: String {
		/// Update this as per your needs!
		"en_US"
	}
}

#Preview {
    ContentView()
}
