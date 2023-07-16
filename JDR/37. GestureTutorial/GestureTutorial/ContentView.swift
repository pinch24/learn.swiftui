//
//  ContentView.swift
//  GestureTutorial
//
//  Created by mk on 2023/07/16.
//

import SwiftUI

struct ContentView: View {
	@State var singleTapped = false
	@State var doubleTapped = false
	@State var tripleTapped = false
	
	var singleTap: some Gesture {
		TapGesture()
			.onEnded { _ in
				print("Single Tapped.")
				singleTapped.toggle()
			}
	}
	
	var doubleTap: some Gesture {
		TapGesture(count: 2)
			.onEnded { _ in
				print("Double Tapped.")
				doubleTapped.toggle()
			}
	}
	
	var tripleTap: some Gesture {
		TapGesture(count: 3)
			.onEnded { _ in
				print("Triple Tapped.")
				tripleTapped.toggle()
			}
	}
	
    var body: some View {
        VStack {
            Circle()
				.fill(singleTapped ? .blue : .gray)
				.frame(width: 100, height: 100, alignment: .center)
				.overlay(Text("Single Tap"))
				.circleTitle()
				.gesture(singleTap)
			Circle()
				.fill(doubleTapped ? .blue : .gray)
				.frame(width: 100, height: 100, alignment: .center)
				.overlay(Text("Double Tap"))
				.circleTitle()
				.gesture(doubleTap)
			Circle()
				.fill(tripleTapped ? .blue : .gray)
				.frame(width: 100, height: 100, alignment: .center)
				.overlay(Text("Triple Tap"))
				.circleTitle()
				.gesture(tripleTap)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CircleTitle: ViewModifier {
	func body(content: Content) -> some View {
		content.font(.system(size: 26)).foregroundColor(.white)
	}
}

extension View {
	func circleTitle() -> some View {
		modifier(CircleTitle())
	}
}
