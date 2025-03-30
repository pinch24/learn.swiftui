//
//  TextFieldReducer.swift
//  TCAWorks
//
//  Created by MK on 3/30/25.
//

import ComposableArchitecture

@Reducer
struct TextFieldReducer {
	@ObservableState
	struct State: Equatable {
		var text: String = ""
		var isFocused: Bool = false
		
		var mode: TextFieldMode = .plain
		var error: String?
		
		init() {}
		init(text: String = "", isFocused: Bool = false, mode: TextFieldMode) {
			self.text = text
			self.isFocused = isFocused
			self.mode = mode
		}
	}
	
	init() {}
	
	enum Action {
		case updateFocus(Bool)
		case textChanged(String)
		case validate
	}
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .updateFocus(let isFocused):
				state.isFocused = isFocused
				return .send(.validate)
			case .textChanged(let text):
				state.text = text
				return .send(.validate)
			case .validate:
				state.error = validate(state)
				return .none
			}
		}
	}
	
	func validate(_ state: State) -> String? {
		switch state.mode {
		case .plain:
			return nil
		case .email:
			if state.text.isEmpty {
				return nil
			} else if state.text.isValidEmail == false {
				return "Invalid email."
			} else {
				return nil
			}
		// case .phone, .url, ...
		}
	}
}

enum TextFieldMode {
	case plain
	case email
}
