//
//  ContentView.swift
//  SwiftCalc
//
//  Created by mk on 12/10/23.
//

import SwiftUI

struct ContentView: View {
	@State private var accumulator = 0.0
	@State private var display = ""
	@State private var memory = 0.0
	@State private var pendingOperation: Operator = .none
	@State private var displayChange = false
	
	func addDisplayText(_ digit: String) {
		if displayChange {
			display = "\(digit)"
			displayChange = false
		} else {
			display += digit
		}
	}
	
	func doOperation(_ opr: Operator) {
		let val = Double(display) ?? 0.0
		switch pendingOperation {
		case .none:
			accumulator = val
		case .add:
			accumulator += val
		case .subtract:
			accumulator -= val
		case .multiply:
			accumulator *= val
		case .divide:
			accumulator /= val
		}
		displayChange = true
		pendingOperation = opr
		display = "\(accumulator)"
	}
	
	let calculatorColumns = [
		GridItem(.fixed(45), spacing: 10),
		GridItem(.fixed(45), spacing: 10),
		GridItem(.fixed(45), spacing: 10),
		GridItem(.fixed(45), spacing: 10),
		GridItem(.fixed(45), spacing: 10)
	]
	
	var body: some View {
		GeometryReader { geometry in
			LazyVStack {
				DisplayView(display: $display)
					.padding(.horizontal, 7)
					.padding()
				if memory != 0.0 {
					MemoryView(memory: $memory, geometry: geometry)
						.padding(.bottom)
						.padding(.horizontal, 5)
				}
				
				LazyVGrid(columns: calculatorColumns, spacing: 10) {
					Group {
						Button {
							memory = 0.0
						} label: {
							Text("MC")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button(action: {
							display = "\(memory)"
						}, label: {
							Text("MR")
						})
						.buttonStyle(CalcButtonStyle())
						
						Button {
							if let val = Double(display) {
								memory += val
								display = ""
								pendingOperation = .none
							} else {
								display = ""
							}
						} label: {
							Text("M+")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							display = ""
						} label: {
							Text("C")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							display = ""
							accumulator = 0.0
							memory = 0.0
						} label: {
							Text("AC")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							let val = Double(display) ?? 0.0
							let root = sqrt(val)
							display = "\(root)"
						} label: {
							Text("√")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							addDisplayText("7")
						} label: {
							Text("7")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							addDisplayText("8")
						} label: {
							Text("8")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							addDisplayText("9")
						} label: {
							Text("9")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							doOperation(.divide)
						} label: {
							Text("÷")
						}
					}
					.buttonStyle(CalcButtonStyle())
					
					Group {
						Button {
							display = "\(Double.pi)"
						} label: {
							Text("π")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							addDisplayText("4")
						} label: {
							Text("4")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							addDisplayText("5")
						} label: {
							Text("5")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							addDisplayText("6")
						} label: {
							Text("6")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							doOperation(.multiply)
						} label: {
							Text("x")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							let val = Double(display) ?? 0.0
							let root = 1.0 / val
							display = "\(root)"
						} label: {
							Text("1/x")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							addDisplayText("1")
						} label: {
							Text("1")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							addDisplayText("2")
						} label: {
							Text("2")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							addDisplayText("3")
						} label: {
							Text("3")
						}
						.buttonStyle(CalcButtonStyle())
						
						Button {
							doOperation(.subtract)
						} label: {
							Text("-")
						}
						.buttonStyle(CalcButtonStyle())
					}
					
					Button {
						let val = Double(display) ?? 0.0
						display = "\(-val)"
					} label: {
						Text("±")
					}
					.buttonStyle(CalcButtonStyle())
					
					Button {
						if !display.contains(".") {
							addDisplayText(".")
						}
					} label: {
						Text(".")
					}
					.buttonStyle(CalcButtonStyle())
					
					Button {
						addDisplayText("0")
					} label: {
						Text("0")
					}
					.buttonStyle(CalcButtonStyle())
					
					Button {
						doOperation(.none)
					} label: {
						Text("=")
					}
					.buttonStyle(CalcButtonStyle())
					
					Button {
						doOperation(.add)
					} label: {
						Text("+")
					}
					.buttonStyle(CalcButtonStyle())
				}
				Spacer()
			}.font(.title)
		}
		.background(
			LinearGradient(
				gradient: Gradient(colors: [.green, .brown, .purple]),
				startPoint: .bottomTrailing,
				endPoint: .topLeading
			)
		)
	}
}

#Preview {
	ContentView()
}

enum Operator {
	case none
	case add
	case subtract
	case multiply
	case divide
}

extension View {
	public func addButtonBorder<S>(
		_ content: S,
		width: CGFloat = 1,
		cornerRadius: CGFloat = 5
	) -> some View where S: ShapeStyle {
		return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: width))
	}
}

struct CalcButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(width: 45, height: 45)
			.addButtonBorder(Color.gray)
			.background(
				RadialGradient(
					gradient: Gradient(
						colors: [Color.white, Color.gray]
					),
					center: .center,
					startRadius: 0,
					endRadius: 80
				)
			)
	}
}
