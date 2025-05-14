//
//  TextFieldView.swift
//  TCAWorks
//
//  Created by MK on 5/14/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TextFieldReducer {
	@ObservableState
	struct State: Equatable {
		var text: String = ""
		var placeholder: String = ""
		
		enum TextFieldMode { case plain, email }
		var mode: TextFieldMode = .plain
		
		var error: String?
		
		init(text: String = "", placeholder: String = "", mode: TextFieldMode = .plain) {
			self.text = text
			self.placeholder = placeholder
			self.mode = mode
		}
	}
	
	enum Action: Equatable {
		case textChanged(String)
		case validate
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .textChanged(let text):
				state.text = text
				return .send(.validate)
				
			case .validate:
				state.error = validate(state)
				return .none
			}
		}
	}
	
	private func validate(_ state: State) -> String? {
		switch state.mode {
		case .plain:
			return nil
		case .email:
			if state.text.isEmpty {
				return nil
			} else if state.text.isValidEmail == false {
				return "유효하지 않은 이메일입니다."
			} else {
				return nil
			}
		}
		// case .phone, .url, ...
	}
}

// MARK: - View
struct TextFieldView: View {
	@FocusState private var isFocused: Bool
	
	private var store: StoreOf<TextFieldReducer>
	private var viewStore: ViewStoreOf<TextFieldReducer>
	init(store: StoreOf<TextFieldReducer>) {
		self.store = store
		self.viewStore = ViewStore(self.store, observe: \.self)
	}
	
	var body: some View {
		TextField(
			viewStore.placeholder,
			text: viewStore.binding(get: \.text, send: { .textChanged($0) })
		)
		.onChange(of: viewStore.text) { oldValue, newValue in
			viewStore.send(.validate)
		}
		.focused($isFocused)
		.modifier(
			TextFieldModifier(
				isFocused: isFocused,
				isEmpty: viewStore.text.isEmpty,
				error: viewStore.error
			)
		)
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

struct TextFieldModifier: ViewModifier {
	var isFocused: Bool = false
	var isEmpty: Bool = false
	var error: String? = nil
	var validate: TextFieldValidation = .empty
	
	init(isFocused: Bool = false, isEmpty: Bool = false, error: String? = nil) {
		if isFocused && isEmpty {
			validate = .focused
		} else if isEmpty {
			validate = .empty
		} else if let error {
			validate = .error(error)
		} else if isFocused {
			validate = .focused
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
					RoundedRectangle(cornerRadius: 16)
						.stroke(borderColor, lineWidth: 1)
				)
			
			if case .error(let message) = validate {
				Text(message)
					.foregroundColor(.red)
			}
		}
	}
	
	private var foregroundColor: Color {
		switch validate {
		case .disabled: return .gray
		default: return .primary
		}
	}
	
	private var backgroundColor: Color {
		switch validate {
		case .disabled: return .gray
		default: return .background
		}
	}
	
	private var borderColor: Color {
		switch validate {
		case .empty: return .secondary
		case .focused: return .accentColor
		case .completed: return .teal
		case .error: return .red
		case .disabled: return .yellow
		}
	}
}

#Preview {
	let store = Store(
		initialState: TextFieldReducer.State(mode: .email),
		reducer: { TextFieldReducer() }
	)
	TextFieldView(store: store)
		.padding()
}
