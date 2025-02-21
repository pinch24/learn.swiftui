//
//  GraphicView.swift
//  TextTransition
//
//  Created by Meng To on 14/6/24.
//

import SwiftUI

struct GraphicView: View {
    var body: some View {
        ZStack() {
            Ellipse()
                .foregroundColor(.clear)
                .frame(width: 300, height: 300)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.09, green: 0.20, blue: 0.64), Color(red: 0.09, green: 0.20, blue: 0.64).opacity(0)]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.05)
                )
                .mask(Circle())
                .overlay(
                    Ellipse()
                        .inset(by: 0.50)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
                .offset(x: 0, y: 0)
            Ellipse()
                .foregroundColor(.clear)
                .frame(width: 240, height: 240)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.09, green: 0.20, blue: 0.64), Color(red: 0.09, green: 0.20, blue: 0.64).opacity(0)]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.2)
                )
                .mask(Circle())
                .overlay(
                    Ellipse()
                        .inset(by: 0.50)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
                .offset(x: 0, y: 0)
            Ellipse()
                .foregroundColor(.clear)
                .frame(width: 180, height: 180)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.09, green: 0.20, blue: 0.64), Color(red: 0.09, green: 0.20, blue: 0.64).opacity(0)]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.3)
                )
                .mask(Circle())
                .overlay(
                    Ellipse()
                        .inset(by: 0.50)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
                .offset(x: 0, y: 0)
            Ellipse()
                .foregroundColor(.clear)
                .frame(width: 120, height: 120)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.09, green: 0.20, blue: 0.64), Color(red: 0.09, green: 0.20, blue: 0.64).opacity(0)]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.4)
                )
                .mask(Circle())
                .overlay(
                    Ellipse()
                        .inset(by: 0.50)
                        .stroke(.white.opacity(0.2), lineWidth: 0.50)
                )
                .offset(x: 0, y: 0)
            
            HStack(spacing: 10) {
                Image(systemName: "point.3.connected.trianglepath.dotted")
                    .symbolEffect(.breathe)
                    .font(Font.custom("SF Pro", size: 40))
                    .lineSpacing(41)
                    .foregroundColor(.white)
            }
            .padding(10)
            .frame(width: 100, height: 100)
            .background(Color(red: 0.09, green: 0.20, blue: 0.64))
            .cornerRadius(100)
            .offset(x: 0, y: 0)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 10, y: 10
            )
            
            HStack(alignment: .top, spacing: 10) {
                ZStack() {
                    
                }
                .frame(width: 24, height: 24)
                .background(.red)
                .cornerRadius(50)
            }
            .padding(10)
            .frame(width: 44, height: 44)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1).opacity(0.10), Color(red: 1, green: 1, blue: 1).opacity(0.10)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .background(.ultraThinMaterial)
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .inset(by: -0.50)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
            .offset(x: -66, y: -87)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 10, y: 10
            )
            
            HStack(alignment: .top, spacing: 10) {
                ZStack() {
                    
                }
                .frame(width: 24, height: 24)
                .background(Color(red: 0.09, green: 0.47, blue: 0.95))
                .cornerRadius(50)
            }
            .padding(10)
            .frame(width: 44, height: 44)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1).opacity(0.10), Color(red: 1, green: 1, blue: 1).opacity(0.10)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .background(.ultraThinMaterial)
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .inset(by: -0.50)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
            .offset(x: -98, y: 46)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 10, y: 10
            )
            
            HStack(alignment: .top, spacing: 10) {
                ZStack() {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 24, height: 24)
                        .background(Color(red: 0.20, green: 0.67, blue: 0.87))
                        .cornerRadius(13.11)
                        .offset(x: 0, y: 0)
                }
                .frame(width: 24, height: 24)
            }
            .padding(10)
            .frame(width: 44, height: 44)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1).opacity(0.10), Color(red: 1, green: 1, blue: 1).opacity(0.10)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .background(.ultraThinMaterial)
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .inset(by: -0.50)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
            .offset(x: 103, y: 12)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 10, y: 10
            )
            
            ZStack() {
                Image("Background03")
                    .resizable()
                    .foregroundColor(.clear)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1).opacity(0.10), Color(red: 1, green: 1, blue: 1).opacity(0.10)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .background(.ultraThinMaterial)
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .inset(by: -0.50)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
                    .offset(x: 0, y: 0)
            }
            .frame(width: 44, height: 44)
            .offset(x: 50, y: -99)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 10, y: 10
            )
            
            ZStack() {
                Image("Background04")
                    .resizable()
                    .foregroundColor(.clear)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1).opacity(0.10), Color(red: 1, green: 1, blue: 1).opacity(0.10)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .background(.ultraThinMaterial)
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .inset(by: -0.50)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
                    .offset(x: 0, y: 0)
            }
            .frame(width: 44, height: 44)
            .offset(x: 18, y: 99)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 10, y: 10
            )
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    GraphicView()
}
