//
//  ContentView.swift
//  Clock
//
//  Created by Meng To on 2023-03-05.
//

import SwiftUI

struct ContentView: View {
    var numbers = [12,1,2,3,4,5,6,7,8,9,10,11]
    var icons = ["calendar", "message", "figure.walk", "music.note"]
    @State var hour: Double = 0
    @State var minute: Double = 0
     
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray.gradient)
                .ignoresSafeArea()
            
            clockCase
            
            RadialLayout {
                ForEach(numbers, id: \.self) { item in
                    Text("\(item)")
                        .font(.system(.title, design: .rounded))
                        .bold()
                        .foregroundColor(.black)
                }
            }
            .frame(width: 240)
            
            RadialLayout {
                ForEach(icons, id: \.self) { item in
                    Circle()
                        .foregroundColor(.black)
                        .frame(width: 44)
                        .overlay(Image(systemName: item)
                            .foregroundColor(.white))
                }
            }
            .frame(width: 120)
            
            Circle()
                .strokeBorder(.black, style: StrokeStyle(lineWidth: 10, dash: [1, 10]))
                .frame(width: 220)
            
            RadialLayout {
                ForEach(numbers, id: \.self) { item in
                    Text("\(item * 5)")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
            .frame(width: 360)
            
            clockHands
        }
        .onAppear {
            hour = 360
            minute = 360
        }
    }
    
    var clockHands: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(.black)
                .frame(width: 8, height: 70)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 1).fill(.white))
                .offset(y: -32)
                .rotationEffect(.degrees(hour), anchor: .center)
                .shadow(radius: 5, y: 5)
                .animation(.linear(duration: 120), value: hour)
            
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(.black)
                .frame(width: 8, height: 100)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 1).fill(.white))
                .offset(y: -46)
                .rotationEffect(.degrees(minute), anchor: .center)
                .shadow(radius: 5, y: 5)
                .animation(.linear(duration: 10).repeatCount(12, autoreverses: false), value: minute)
            
            Circle()
                .fill(.white)
                .frame(width: 3)
        }
    }
    
    var clockCase: some View {
        ZStack {
            Circle()
                .foregroundStyle(
                    .gray
                    .shadow(.inner(color: .gray, radius: 30, x: 30, y: 30))
                    .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: -1, y: -1))
                    .shadow(.inner(color: .black.opacity(0.2), radius: 0, x: 1, y: 1))
                )
                .frame(width: 360)
            
            Circle()
                .foregroundStyle(
                    .white
                    .shadow(.inner(color: .gray, radius: 30, x: -30, y: -30))
                    .shadow(.drop(color: .black.opacity(0.3), radius: 30, x: 30, y: 30))
                )
                .frame(width: 320)
            
            Circle()
                .foregroundStyle(.white.shadow(.inner(color: .gray, radius: 30, x: 30, y: 30)))
                .frame(width: 280)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RadialLayout: Layout {
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let radius = min(bounds.size.width, bounds.size.height) / 3.0
        let angle = Angle.degrees(360.0 / Double(subviews.count)).radians

        for (index, subview) in subviews.enumerated() {
            var point = CGPoint(x: 0, y: -radius)
                .applying(CGAffineTransform(
                    rotationAngle: angle * Double(index)))

            point.x += bounds.midX
            point.y += bounds.midY

            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}
