//
//  CardView.swift
//  ProgressiveBlur
//
//  Created by Meng To on 20/6/24.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: "timelapse")
                    .font(Font.custom("SF Pro", size: 17))
                    .foregroundColor(.white)
                Text("Docs updated Jun 2024")
                    .font(.footnote)
                    .foregroundColor(Color(red: 1, green: 1, blue: 1).opacity(0.50))
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .background(
                LinearGradient(gradient: Gradient(colors: [.white, Color(red: 1, green: 1, blue: 1).opacity(0.50)]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.1)
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.50)
                    .stroke(.white.opacity(0.5), lineWidth: 0.50)
            )
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.50), radius: 60, y: 30
            )
            HStack(alignment: .top, spacing: 8) {
                Text("What’s the best way to learn SwiftUI?")
                    .font(Font.custom("SF Pro", size: 15))
                    .lineSpacing(20)
                    .foregroundColor(Color(red: 1, green: 1, blue: 1).opacity(0.80))
            }
            .padding(8)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1).opacity(0), Color(red: 1, green: 1, blue: 1).opacity(0.52)]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.5)
            )
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.50)
                    .stroke(.white.opacity(0.5), lineWidth: 0.50)
            )
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 20, y: 20
            )
            HStack(spacing: 8) {
                ZStack() {
                    Ellipse()
                        .foregroundColor(.clear)
                        .frame(width: 24, height: 24)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1).opacity(0), Color(red: 1, green: 1, blue: 1).opacity(0.52)]), startPoint: .top, endPoint: .bottom)
                        )
                        .cornerRadius(15)
                        .overlay(
                            Ellipse()
                                .inset(by: 0.50)
                                .stroke(.white, lineWidth: 0.50)
                        )
                        .offset(x: 0, y: 0)
                    Image(systemName: "record.circle")
                        .font(Font.custom("SF Pro", size: 15))
                        .lineSpacing(20)
                        .foregroundColor(Color(red: 1, green: 1, blue: 1).opacity(0.80))
                        .offset(x: 0, y: 0)
                }
                .frame(width: 24, height: 24)
                Text("SwiftUI-Assistant")
                    .font(.footnote)
                    .foregroundColor(Color(red: 1, green: 1, blue: 1).opacity(0.80))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Learning Path")
                        .font(.body).bold()
                        .foregroundColor(Color(red: 1, green: 1, blue: 1).opacity(1))
                    Text("We suggest making this course your trusty sidekick, pairing it up with the handy SwiftUI handbook and our other awesome SwiftUI courses. As you get more cozy with SwiftUI and Swift, feel free to level up and venture into our more advanced courses. Here's a little roadmap to guide your learning journey")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 1, green: 1, blue: 1).opacity(0.80))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(.black.opacity(0.10))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: -0.50)
                    .stroke(
                        Color(red: 1, green: 1, blue: 1).opacity(0.20), lineWidth: 0.50
                    )
            )
            HStack {
                Text("Start chat with SwiftUI-Assistant...")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Image(systemName: "paperclip")
                    .foregroundColor(.white)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [.white, Color(red: 1, green: 1, blue: 1).opacity(0.10)]), startPoint: .bottom, endPoint: .top)
                    .opacity(0.1)
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.50)
                    .stroke(.white.opacity(0.2), lineWidth: 0.50)
            )
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.50), radius: 60, y: 30
            )
        }
        .padding(20)
        .frame(width: 320, height: 454)
        .background(.black.blendMode(.softLight))
        .background(.ultraThinMaterial)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1).opacity(0), Color(red: 1, green: 1, blue: 1).opacity(0.52)]), startPoint: .top, endPoint: .bottom)
                .opacity(0.5)
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .inset(by: 0.50)
                .stroke(.white.opacity(0.2), lineWidth: 0.50)
        )
        .shadow(
            color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 20, y: 20
        )
    }
}

#Preview {
    ZStack {
        CardView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(Image("Background").resizable())
}
