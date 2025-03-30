//
//  TextField+Extension.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import SwiftUI
import ComposableArchitecture

extension TextField {
	func state(_ state: TextFieldReducer.State) -> some View {
		self.modifier(TextFieldModifier(state: state))
	}
}

struct TextFieldModifier: ViewModifier {
	var state: TextFieldReducer.State?
	var validate: TextFieldValidation = .empty
	
	init(state: TextFieldReducer.State) {
		self.state = state
		
		if state.isFocused && state.text.isEmpty {
			validate = .focused
		} else if state.text.isEmpty {
			validate = .empty
		} else if state.error != nil {
			validate = .error(state.error ?? "ERROR")
		} else if state.isFocused {
			validate = .focused
		} else {
			validate = .completed
		}
	}
	
	func body(content: Content) -> some View {
		VStack(alignment: .leading) {
			content
				.foregroundColor(foregroundColor)
				.background(backgroundColor)
				.disabled(validate == .disabled)
				.padding(12)
				.overlay(
					RoundedRectangle(cornerRadius: 8)
						.stroke(borderColor, lineWidth: 1)
				)
			
			if case .error(let string) = validate {
				Text(string)
					.font(.caption)
					.foregroundColor(.red)
			}
		}
	}
	
	private var foregroundColor: Color {
		switch validate {
		case .disabled:
			return .gray
		default:
			return .primary
		}
	}
	
	private var backgroundColor: Color {
		switch validate {
		case .disabled:
			return .gray
		default:
			return .background
		}
	}
	
	private var borderColor: Color {
		switch validate {
		case .empty:
			return .secondary
		case .focused:
			return .blue
		case .completed:
			return .primary
		case .error:
			return .red
		case .disabled:
			return .gray
		}
	}
}

enum TextFieldValidation: Equatable {
	case empty
	case focused
	case completed
	case error(String)
	case disabled
	// case editing
}


#Preview {
    TextField_Preview()
}

struct TextField_Preview: View {
	let store = Store(initialState: TextFieldReducer.State(mode: .email), reducer: { TextFieldReducer() })
	@FocusState private var isFocused: Bool
	
	var body: some View {
		VStack(alignment: .trailing) {
			TextField("Email", text: Binding(get: { store.text }, set: { store.send(.textChanged($0)) }))
				.state(store.state)
				.focused($isFocused)
				.onChange(of: isFocused) { _, newValue in
					store.send(.updateFocus(newValue))
				}
			Text("\(store.error ?? "_"), \(isFocused)")
				.foregroundStyle(.secondary)
		}
		.padding()
		.frame(width: 320, height: 480)
	}
}
