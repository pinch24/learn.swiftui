//
//  ContentView.swift
//  TextTransition
//
//  Created by Meng To on 14/6/24.
//

import SwiftUI

struct ContentView: View {
    @State var isVisible = true

    var body: some View {
        VStack (spacing: 40) {
            VStack (spacing: 20) {
                if isVisible {
                    GraphicView()
                        .transition(ZoomBlurTransition())
                    Text("Share your Achievements")
                        .customAttribute(EmphasisAttribute())
                        .foregroundStyle(.primary)
                        .font(.system(size: 34, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(TextTransition())
                    Text("Invite friends to support, challenge, and cheer each other. Share workouts, receive progress notifications, and send message right from the Move app.")
                        .foregroundStyle(.primary.opacity(0.7))
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.asymmetric(
                            insertion: .opacity.animation(.easeInOut.delay(0.5)),
                            removal: .opacity.animation(.easeInOut)
                        ))
                }
            }
            
            Button {
                withAnimation(.easeInOut.delay(isVisible ? 0.5 : 0)) {
                    isVisible.toggle()
                }
            } label: {
                Text(isVisible ? "Sign up" : "Get started")
                    .foregroundColor(Color(.systemBackground))
            }
            .buttonStyle(.borderedProminent)
            .tint(.primary)
            .controlSize(.extraLarge)
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20)
            .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 15)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .padding(40)
    }
}

struct ZoomBlurTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .scaleEffect(phase.isIdentity ? 1 : 0.5)
            .opacity (phase.isIdentity ? 1 : 0)
            .blur (radius: phase.isIdentity ? 0 : 10)
    }
}

#Preview {
    ContentView()
}
