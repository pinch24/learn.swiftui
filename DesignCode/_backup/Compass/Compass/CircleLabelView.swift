//
//  CircleLabelView.swift
//  Compass
//
//  Created by Meng To on 2023-03-05.
//

import SwiftUI

struct CircleLabelView: View {
    var radius: Double
    var text: String
    var kerning: CGFloat = 4
    var size: CGSize = .init(width: 300, height: 300)
    
    var texts: [(offset: Int, element: Character)] {
        return Array(text.enumerated())
    }
    
    @State var textWidths: [Int:Double] = [:]
    
    var body: some View {
        ZStack {
            ForEach(texts, id: \.offset) { index, letter in
                VStack {
                    Text(String(letter))
                        .kerning(kerning)
                        .background(Sizeable())
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { width in
                            textWidths[index] = width
                        })
                    Spacer()
                }
                .rotationEffect(angle(at: index))
            }
        }
        .rotationEffect(-angle(at: texts.count-1)/2)
        .frame(width: size.width, height: size.height)
    }
    
    func angle(at index: Int) -> Angle {
        guard let labelWidth = textWidths[index] else { return .radians(0) }
        
        let circumference = radius * 2 * .pi
        
        let percent = labelWidth / circumference
        let labelAngle = percent * 2 * .pi
        
        let widthBeforeLabel = textWidths.filter{$0.key < index}.map{$0.value}.reduce(0, +)
        let percentBeforeLabel = widthBeforeLabel / circumference
        let angleBeforeLabel = percentBeforeLabel * 2 * .pi
        
        return .radians(angleBeforeLabel + labelAngle)
    }
}

struct CircleLabelView_Previews: PreviewProvider {
    static var previews: some View {
        CircleLabelView(
            radius: 150,
            text: "Latitude 35.08587 E • Longitude 21.43673 W • Elevation 64M • Incline 12 •".uppercased()
        )
        .font(.system(size: 13, design: .monospaced)).bold()
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: Double = 0
    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}

struct Sizeable: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}
