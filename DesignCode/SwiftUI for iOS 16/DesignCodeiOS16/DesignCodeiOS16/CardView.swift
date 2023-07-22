//
//  CardView.swift
//  DesignCodeiOS16
//
//  Created by mk on 2023/07/22.
//

import SwiftUI

struct CardView: View {
	var body: some View {
		Grid {
			GridRow {
				card
				card
			}
			GridRow {
				card.gridCellColumns(2)
			}
			GridRow {
				card
				card
			}
		}
		.padding()
	}
	
    var card: some View {
		VStack(spacing: 12) {
			Image(systemName: "aspectratio")
				.frame(width: 44, height: 44)
				.foregroundStyle(
					.linearGradient(colors: [.white, .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
				.background(
					HexagonShape()
						.stroke()
						.foregroundStyle(
							.linearGradient(colors: [.white.opacity(0.5), .clear], startPoint: .topLeading, endPoint: .bottomTrailing)))
				.background(
					HexagonShape()
						.foregroundStyle(
							.linearGradient(colors: [.clear, .white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)))
			Text("Up to 8K resulution".uppercased())
				.font(.title3.width(.condensed).bold())
				.multilineTextAlignment(.center)
			Text("From huge monitors to the phone, your wallpaper will look great anywhere.")
				.font(.footnote)
				.multilineTextAlignment(.center)
				.opacity(0.7)
				.frame(maxWidth: .infinity)
		}
		.frame(maxHeight: .infinity)
		.padding()
		.padding(.vertical)
		.background(.black)
		.foregroundColor(.white)
		.cornerRadius(20)
		.overlay(
			RoundedRectangle(cornerRadius: 20)
				.stroke()
				.fill(.white.opacity(0.2))
		)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}

struct HexagonShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.size.width
		let height = rect.size.height
		path.move(to: CGPoint(x: 0.28917*width, y: 0.13847*height))
		path.addCurve(to: CGPoint(x: 0.37711*width, y: 0.09254*height), control1: CGPoint(x: 0.33411*width, y: 0.1131*height), control2: CGPoint(x: 0.35563*width, y: 0.10099*height))
		path.addCurve(to: CGPoint(x: 0.62289*width, y: 0.09254*height), control1: CGPoint(x: 0.45597*width, y: 0.06155*height), control2: CGPoint(x: 0.54403*width, y: 0.06155*height))
		path.addCurve(to: CGPoint(x: 0.71082*width, y: 0.13847*height), control1: CGPoint(x: 0.64438*width, y: 0.10099*height), control2: CGPoint(x: 0.66589*width, y: 0.1131*height))
		path.addCurve(to: CGPoint(x: 0.79547*width, y: 0.18997*height), control1: CGPoint(x: 0.75576*width, y: 0.16384*height), control2: CGPoint(x: 0.77725*width, y: 0.176*height))
		path.addCurve(to: CGPoint(x: 0.91836*width, y: 0.39809*height), control1: CGPoint(x: 0.86235*width, y: 0.24125*height), control2: CGPoint(x: 0.90637*width, y: 0.31582*height))
		path.addCurve(to: CGPoint(x: 0.92165*width, y: 0.49551*height), control1: CGPoint(x: 0.92162*width, y: 0.4205*height), control2: CGPoint(x: 0.92165*width, y: 0.44478*height))
		path.addCurve(to: CGPoint(x: 0.91836*width, y: 0.59294*height), control1: CGPoint(x: 0.92165*width, y: 0.54625*height), control2: CGPoint(x: 0.92162*width, y: 0.57052*height))
		path.addCurve(to: CGPoint(x: 0.79547*width, y: 0.80106*height), control1: CGPoint(x: 0.90637*width, y: 0.67521*height), control2: CGPoint(x: 0.86235*width, y: 0.74978*height))
		path.addCurve(to: CGPoint(x: 0.71082*width, y: 0.85256*height), control1: CGPoint(x: 0.77725*width, y: 0.81503*height), control2: CGPoint(x: 0.75576*width, y: 0.82719*height))
		path.addCurve(to: CGPoint(x: 0.62289*width, y: 0.89848*height), control1: CGPoint(x: 0.66589*width, y: 0.87793*height), control2: CGPoint(x: 0.64438*width, y: 0.89004*height))
		path.addCurve(to: CGPoint(x: 0.37711*width, y: 0.89848*height), control1: CGPoint(x: 0.54403*width, y: 0.92947*height), control2: CGPoint(x: 0.45597*width, y: 0.92947*height))
		path.addCurve(to: CGPoint(x: 0.28917*width, y: 0.85256*height), control1: CGPoint(x: 0.35563*width, y: 0.89004*height), control2: CGPoint(x: 0.33411*width, y: 0.87793*height))
		path.addCurve(to: CGPoint(x: 0.20453*width, y: 0.80106*height), control1: CGPoint(x: 0.24424*width, y: 0.82719*height), control2: CGPoint(x: 0.22275*width, y: 0.81503*height))
		path.addCurve(to: CGPoint(x: 0.08164*width, y: 0.59294*height), control1: CGPoint(x: 0.13765*width, y: 0.74978*height), control2: CGPoint(x: 0.09363*width, y: 0.67521*height))
		path.addCurve(to: CGPoint(x: 0.07835*width, y: 0.49551*height), control1: CGPoint(x: 0.07838*width, y: 0.57052*height), control2: CGPoint(x: 0.07835*width, y: 0.54625*height))
		path.addCurve(to: CGPoint(x: 0.08164*width, y: 0.39809*height), control1: CGPoint(x: 0.07835*width, y: 0.44478*height), control2: CGPoint(x: 0.07838*width, y: 0.4205*height))
		path.addCurve(to: CGPoint(x: 0.20453*width, y: 0.18997*height), control1: CGPoint(x: 0.09363*width, y: 0.31582*height), control2: CGPoint(x: 0.13765*width, y: 0.24125*height))
		path.addCurve(to: CGPoint(x: 0.28917*width, y: 0.13847*height), control1: CGPoint(x: 0.22275*width, y: 0.176*height), control2: CGPoint(x: 0.24424*width, y: 0.16384*height))
		path.closeSubpath()
		return path
	}
}
