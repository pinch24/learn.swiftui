//
//  LaunchView.swift
//  EduTech
//

import SwiftUI

struct LaunchView: View {
    @State private var stage = 0
    @State private var dots = 0
    @State private var float = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(white: 0.98), Color(white: 0.92)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                ScholarIllustration(stage: stage)
                    .frame(width: 260, height: 260)
                    .offset(y: float ? -6 : 6)
                    .animation(
                        .easeInOut(duration: 2.4).repeatForever(autoreverses: true),
                        value: float
                    )

                VStack(spacing: 8) {
                    Text("EduTech")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                        .opacity(stage >= 4 ? 1 : 0)
                        .offset(y: stage >= 4 ? 0 : 12)
                        .animation(.spring(response: 0.6, dampingFraction: 0.75), value: stage)

                    Text("Learning, reimagined" + String(repeating: ".", count: dots))
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(height: 20)
                        .opacity(stage >= 5 ? 1 : 0)
                        .animation(.easeIn(duration: 0.5), value: stage)
                }

                Spacer()

                ProgressView()
                    .tint(.black)
                    .padding(.bottom, 48)
                    .opacity(stage >= 5 ? 1 : 0)
                    .animation(.easeIn(duration: 0.5), value: stage)
            }
        }
        .onAppear(perform: runSequence)
    }

    private func runSequence() {
        let steps: [Double] = [0.15, 0.25, 0.25, 0.35, 0.25, 0.25]
        var delay: Double = 0
        for step in steps {
            delay += step
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
                    stage += 1
                }
            }
        }
        float = true
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            dots = (dots + 1) % 4
        }
    }
}

struct ScholarIllustration: View {
    let stage: Int

    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            ZStack {
                LeafShape()
                    .fill(Color.black.opacity(0.85))
                    .frame(width: s * 0.32, height: s * 0.42)
                    .offset(x: -s * 0.34, y: s * 0.18)
                    .rotationEffect(.degrees(stage >= 1 ? 0 : -18), anchor: .bottom)
                    .opacity(stage >= 1 ? 1 : 0)
                    .modifier(LeafSway(active: stage >= 5))

                BookStack(stage: stage)
                    .frame(width: s * 0.75, height: s * 0.28)
                    .offset(y: s * 0.28)

                WomanFigure(stage: stage)
                    .frame(width: s * 0.7, height: s * 0.65)
                    .offset(y: -s * 0.05)
                    .scaleEffect(stage >= 3 ? 1 : 0.7, anchor: .bottom)
                    .opacity(stage >= 3 ? 1 : 0)
            }
            .frame(width: s, height: s)
        }
    }
}

private struct LeafSway: ViewModifier {
    let active: Bool
    @State private var sway = false

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(active && sway ? 4 : -4), anchor: .bottom)
            .animation(
                active ? .easeInOut(duration: 2.8).repeatForever(autoreverses: true) : .default,
                value: sway
            )
            .onAppear { if active { sway = true } }
            .onChange(of: active) { _, newValue in sway = newValue }
    }
}

private struct BookStack: View {
    let stage: Int

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let bookH = h / 3.2
            VStack(spacing: h * 0.03) {
                book(width: w * 0.92, height: bookH, fill: .black, visible: stage >= 2)
                book(width: w * 1.0, height: bookH, fill: Color(white: 0.15), visible: stage >= 1)
                book(width: w * 0.88, height: bookH, fill: .black, visible: stage >= 1)
            }
            .frame(width: w, height: h, alignment: .center)
        }
    }

    private func book(width: CGFloat, height: CGFloat, fill: Color, visible: Bool) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 2)
                .fill(fill)
            Rectangle()
                .fill(Color.white.opacity(0.9))
                .frame(width: height * 0.25)
                .padding(.vertical, height * 0.18)
                .padding(.leading, height * 0.35)
        }
        .frame(width: width, height: height)
        .opacity(visible ? 1 : 0)
        .offset(y: visible ? 0 : 24)
        .scaleEffect(x: visible ? 1 : 0.85, anchor: .center)
    }
}

private struct WomanFigure: View {
    let stage: Int
    @State private var screenGlow = false

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                HairBack()
                    .fill(Color.black)
                    .frame(width: w * 0.42, height: h * 0.55)
                    .offset(x: -w * 0.02, y: -h * 0.18)

                Circle()
                    .fill(Color.white)
                    .frame(width: w * 0.26, height: w * 0.26)
                    .offset(x: w * 0.02, y: -h * 0.28)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 2.5)
                            .frame(width: w * 0.26, height: w * 0.26)
                            .offset(x: w * 0.02, y: -h * 0.28)
                    )

                HairFront()
                    .fill(Color.black)
                    .frame(width: w * 0.32, height: h * 0.32)
                    .offset(x: -w * 0.04, y: -h * 0.32)

                TorsoShape()
                    .fill(Color.black)
                    .frame(width: w * 0.55, height: h * 0.45)
                    .offset(x: w * 0.0, y: h * 0.05)

                LegsShape()
                    .fill(Color.black)
                    .frame(width: w * 0.75, height: h * 0.28)
                    .offset(x: w * 0.05, y: h * 0.28)

                LaptopShape()
                    .fill(Color.black)
                    .frame(width: w * 0.5, height: h * 0.2)
                    .offset(x: w * 0.18, y: h * 0.12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white)
                            .frame(width: w * 0.42, height: h * 0.13)
                            .offset(x: w * 0.18, y: h * 0.1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.black.opacity(screenGlow ? 0.0 : 0.25),
                                                Color.black.opacity(screenGlow ? 0.25 : 0.0)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: w * 0.42, height: h * 0.13)
                                    .offset(x: w * 0.18, y: h * 0.1)
                                    .opacity(stage >= 4 ? 1 : 0)
                            )
                    )
            }
        }
        .onChange(of: stage) { _, newValue in
            if newValue >= 4 {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                    screenGlow = true
                }
            }
        }
    }
}

private struct HairBack: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX * 0.95, y: rect.maxY),
            control: CGPoint(x: rect.maxX * 1.1, y: rect.midY)
        )
        p.addLine(to: CGPoint(x: rect.minX * 1.0 + rect.width * 0.15, y: rect.maxY))
        p.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX - rect.width * 0.1, y: rect.midY)
        )
        return p
    }
}

private struct HairFront: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: rect.maxX * 1.05, y: rect.minY + rect.height * 0.1)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX * 0.7, y: rect.maxY * 0.6),
            control: CGPoint(x: rect.maxX * 0.95, y: rect.maxY * 0.7)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.midX * 0.5, y: rect.maxY * 1.0)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX - rect.width * 0.05, y: rect.minY)
        )
        return p
    }
}

private struct TorsoShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX - rect.width * 0.15, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: rect.maxX * 1.05, y: rect.minY + rect.height * 0.1)
        )
        p.addLine(to: CGPoint(x: rect.maxX * 0.85, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.maxY))
        p.addQuadCurve(
            to: CGPoint(x: rect.midX - rect.width * 0.15, y: rect.minY),
            control: CGPoint(x: rect.minX - rect.width * 0.05, y: rect.midY)
        )
        return p
    }
}

private struct LegsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: rect.maxX * 0.7, y: rect.minY - rect.height * 0.1)
        )
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.75))
        p.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        p.closeSubpath()
        return p
    }
}

private struct LaptopShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let inset: CGFloat = rect.height * 0.15
        p.move(to: CGPoint(x: rect.minX + inset, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - inset, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

private struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.maxX * 1.3, y: rect.midY)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX - rect.width * 0.3, y: rect.midY)
        )
        return p
    }
}

#Preview {
    LaunchView()
}
