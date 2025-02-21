//
//  ContentView.swift
//  Compass
//
//  Created by Meng To on 2023-03-05.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = MotionManager()
    @ObservedObject var compassHeading = CompassHeading()
    @State var show = false
    @State var translation: CGSize = .zero
    @State var location: CGPoint = .zero
    @State var isDragging = false
    @State var press = false
    @State var offset = 0.0
    
    var body: some View {
        ZStack {
            background
            outerCircles
                .frame(width: 393)
            innerCircles
                .frame(width: 393)
            flashlight
            waypoints
                .rotationEffect(Angle(degrees: compassHeading.degrees))
                .scaleEffect(show ? 0.9 : 1)
            circleLabel
                .rotation3DEffect(.degrees(show ? 10 : 0), axis: (x: 1, y: 0, z: 0))
            strokes
                .rotationEffect(Angle(degrees: compassHeading.degrees))
                .rotation3DEffect(.degrees(show ? 10 : 0), axis: (x: 1, y: 0, z: 0))
            light
            title
        }
        .overlay(buttons)
        .overlay(sheet.animation(.easeOut(duration: 0.5), value: show))
        .gesture(drag)
    }
    
    var flashlight: some View {
        GeometryReader { proxy in
            ZStack {
                Circle()
                    .fill(.radialGradient(colors: [.white.opacity(0.1), .clear], center: .center, startRadius: 0, endRadius: 200))
                    .offset(x: location.x-proxy.size.width/2, y: location.y-proxy.size.height/2)
                    .opacity(isDragging ? 1 : 0)
                
                Circle()
                    .fill(.radialGradient(colors: [.white.opacity(1), .clear], center: .center, startRadius: 0, endRadius: 200))
                    .offset(x: location.x-proxy.size.width/2, y: location.y-proxy.size.height/2)
                    .opacity(isDragging ? 1 : 0)
                    .mask(
                        ZStack {
                            Circle()
                                .stroke()
                                .scaleEffect(1.2)
                            Circle()
                                .stroke()
                                .scaleEffect(1.5)
                            Circle()
                                .stroke()
                                .padding(20)
                            Circle()
                                .stroke()
                                .padding(80)
                            Circle()
                                .stroke()
                                .padding(100)
                            Circle()
                                .stroke()
                                .padding(120)
                            Circle()
                                .stroke()
                                .padding(145)
                            Circle()
                                .stroke()
                                .padding(170)
                            
                            ZStack {
                                Text("Home")
                                    .offset(x: 0, y: -210)
                                    .rotationEffect(.degrees(-31))
                                Text("Tent")
                                    .rotationEffect(.degrees(35))
                                    .offset(x: 115, y: -170)
                                Text("Parked Car")
                                    .rotationEffect(.degrees(150))
                                    .offset(x: 80, y: 190)
                            }
                            .fontWeight(.medium)
                            
                            ZStack {
                                Text("N")
                                    .offset(x: 0, y: -135)
                                Text("E")
                                    .rotationEffect(.degrees(90))
                                    .offset(x: 135, y: 0)
                                Text("S")
                                    .rotationEffect(.degrees(180))
                                    .offset(x: 0, y: 135)
                                Text("W")
                                    .rotationEffect(.degrees(270))
                                    .offset(x: -135, y: 0)
                            }
                            .fontWeight(.medium)
                        }
                            .frame(width: 393)
                            .rotationEffect(Angle(degrees: compassHeading.degrees))
                    )
            }
            .frame(
                width: proxy.frame(in: .global).width,
                height: proxy.frame(in: .global).height
            )
            .opacity(show ? 0 : 1)
        }
    }
    
    var title: some View {
        VStack {
            Text("\(String(format: "%.0f", abs(compassHeading.degrees)))º \(Direction(compassHeading.degrees))".uppercased())
                .font(.largeTitle)
            Text("San Francisco".uppercased())
                .font(.footnote)
                .fontWeight(.medium)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    var background: some View {
        Rectangle()
            .fill(.radialGradient(colors: [Color(#colorLiteral(red: 0.2970857024, green: 0.3072845936, blue: 0.4444797039, alpha: 1)), .black], center: .center, startRadius: 1, endRadius: 400))
            .ignoresSafeArea()
    }
    
    var circleLabel: some View {
        CircleLabelView(radius: 135, text: "Latitude 35.08587 E • Longitude 21.43673 W • Elevation 64M • Incline 12 •".uppercased(), kerning: 3, size: CGSize(width: 225, height: 225))
            .foregroundStyle(.white)
            .font(.system(size: 12, weight: .bold, design: .monospaced))
            .bold()
    }
    
    var buttons: some View {
        HStack(spacing: 30) {
            Button {
                withAnimation {
                    show.toggle()
                }
                withAnimation(.spring()) {
                    press = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        press = false
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 64, height: 44)
                    .foregroundStyle(
                        .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
                        .shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
                        .shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
                    )
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                .overlay(Image(systemName: "list.bullet").foregroundStyle(.white))
            }
            .scaleEffect(press ? 1.2 : 1)

            RoundedRectangle(cornerRadius: 30)
                .frame(width: 52, height: 52)
                .foregroundStyle(
                    .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
                    .shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
                    .shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
                )
                .overlay(
                    Circle()
                        .fill(.linearGradient(colors: [Color(#colorLiteral(red: 1, green: 0.7176470588, blue: 0.6980392157, alpha: 1)), Color(#colorLiteral(red: 0.7764705882, green: 0.3411764706, blue: 0.3098039216, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 32, height: 32)
                )
                .overlay(
                    Circle()
                        .stroke(.white, style: StrokeStyle(lineWidth: 1, dash: [1, 1]))
                        .frame(width: 22, height: 22)
                )
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                .overlay(Image(systemName: "plus").foregroundStyle(.white))

            RoundedRectangle(cornerRadius: 30)
                .frame(width: 64, height: 44)
                .foregroundStyle(
                    .linearGradient(colors: [Color(#colorLiteral(red: 0.3408924341, green: 0.3429200053, blue: 0.3997989893, alpha: 1)), Color(#colorLiteral(red: 0.02498620935, green: 0.04610963911, blue: 0.08353561908, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: 1, y: 1))
                    .shadow(.inner(color: .white.opacity(0.05), radius: 4, x: 0, y: -4))
                    .shadow(.drop(color: .black.opacity(0.5), radius: 30, y: 30))
                )
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 1))
                .overlay(Image(systemName: "location.north.circle.fill").foregroundStyle(.white))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .offset(y: -100)
    }
    
    var strokes: some View {
        ZStack {
            Circle()
                .strokeBorder(gradient, style: StrokeStyle(lineWidth: 5, dash: [1, 1]))
            Circle()
                .strokeBorder(gradient, style: StrokeStyle(lineWidth: 10, dash: [1, 6]))
            Circle()
                .strokeBorder(gradient, style: StrokeStyle(lineWidth: 15, dash: [1, 62]))
            
        }
        .frame(width: 315, height: 315)
    }
    
    var light: some View {
        Circle()
            .trim(from: 0.6, to: 0.9)
            .stroke(.radialGradient(colors: [.white.opacity(0.2), .white.opacity(0)], center: .center, startRadius: 0, endRadius: 200), style: StrokeStyle(lineWidth: 200))
            .frame(width: 200, height: 200)
    }
    
    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(#colorLiteral(red: 0.61807781457901, green: 0.6255635619163513, blue: 0.7079070806503296, alpha: 1)), location: 0),
                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
    
    var outerCircles: some View {
        ZStack {
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.5), radius: 0, x: 0.5, y: 0.5))
                )
                .scaleEffect(show ? 1.5 : 1.2)
            .rotation3DEffect(.degrees(show ? 25 : 0), axis: (x: 1, y: 0, z: 0))
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.5), radius: 0, x: 0.5, y: 0.5))
                )
                .scaleEffect(show ? 2 : 1.5)
                .rotation3DEffect(.degrees(show ? 30 : 0), axis: (x: 1, y: 0, z: 0))
        }
    }
    
    var innerCircles: some View {
        ZStack {
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [Color(#colorLiteral(red: 0.03137254902, green: 0.0431372549, blue: 0.06666666667, alpha: 1)), Color(#colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.3254901961, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.25), radius: 0, x: 1, y: 1))
                    .shadow(.drop(color: .black.opacity(0.25), radius: 0, x: 1, y: 1))
                )
                .padding(20)
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [Color(#colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1529411765, alpha: 1)), Color(#colorLiteral(red: 0.06666666667, green: 0.07058823529, blue: 0.137254902, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.drop(color: .white.opacity(0.25), radius: 0, x: 1, y: 1))
                    .shadow(.inner(color: .black.opacity(0.25), radius: 0, x: 1, y: 1))
                )
                .padding(80)
            
            Circle()
                .foregroundStyle(
                    .radialGradient(colors: [Color(#colorLiteral(red: 0.03921568627, green: 0.0431372549, blue: 0.1215686275, alpha: 1)), Color(#colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.3215686275, alpha: 1))], center: .center, startRadius: 0, endRadius: 100)
                    .shadow(.inner(color: .white.opacity(0.25), radius: 0, x: 1, y: 1))
                    .shadow(.drop(color: .black.opacity(0.25), radius: 0, x: 1, y: 1))
                )
                .padding(100)
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.5), radius: 0, x: 1, y: 1))
                )
                .padding(120)
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.5), radius: 0, x: 1, y: 1))
                )
                .padding(145)
            
            Circle()
                .foregroundStyle(
                    .linearGradient(colors: [.black.opacity(0.5), .black.opacity(0.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white.opacity(0.5), radius: 0, x: 1, y: 1))
                )
                .padding(170)
            
            Circle()
                .foregroundStyle(.white)
                .padding(188)
        }
        .rotation3DEffect(.degrees(show ? 15 : 0), axis: (x: 1, y: 0, z: 0))
    }
    
    var waypoints: some View {
        ZStack {
            Circle()
                .fill(.blue)
                .frame(width: 16, height: 16)
                .offset(x: 100, y: 210)
            
            Circle()
                .fill(.red)
                .frame(width: 16, height: 16)
                .offset(x: -120, y: -200)
            
            Circle()
                .fill(.green)
                .frame(width: 16, height: 16)
                .offset(x: 100, y: -150)
        }
    }
    
    var sheet: some View {
        CompassSheet(degrees: $compassHeading.degrees, show: $show)
            .background(.black.opacity(0.5))
            .background(.ultraThinMaterial)
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white.opacity(0.2))
                    .frame(width: 40, height: 5)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .offset(y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .strokeBorder(.linearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .offset(y: show ? 340+offset : 1000)
            .offset(y: translation.height)
            .gesture(dragSheet)
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                location = value.location
                isDragging = true
            }
            .onEnded { value in
                withAnimation {
                    translation = .zero
                    isDragging = false
                }
            }
    }
    
    var dragSheet: some Gesture {
        DragGesture()
            .onChanged { value in
                translation = value.translation
            }
            .onEnded { value in
                withAnimation {
                    let offsetY = translation.height
                    
                    if offsetY > 150-offset {
                        show.toggle()
                    }
                    
                    if offsetY < -100-offset {
                        offset = -280
                    } else {
                        offset = 0
                    }
                    
                    translation = .zero
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
