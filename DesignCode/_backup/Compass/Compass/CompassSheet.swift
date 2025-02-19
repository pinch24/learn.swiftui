//
//  CompassSheet.swift
//  Compass
//
//  Created by Meng To on 2023-03-05.
//

import SwiftUI

struct CompassSheet: View {
    @Binding var degrees: Double
    @Binding var show: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 30) {
                InfoRow(title: "Incline", text: "20º")
                InfoRow(title: "Elevation", text: "64M")
                InfoRow(title: "Latitude", text: "35.08587 E")
                InfoRow(title: "Longitude", text: "48.1255 W")
                arrow
                Spacer()
            }
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .mask {
                Rectangle().fill(.linearGradient(colors: [.white, .white, .white.opacity(0.5), .clear], startPoint: .top, endPoint: .bottom))
            }
            .opacity(show ? 1 : 0)
            .blur(radius: show ? 0 : 20)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Waypoints".uppercased())
                    .font(.caption.weight(.medium))
                    .opacity(0.5)
                WaypointView(rotation: 200, degrees: degrees)
                WaypointView(title: "Home", icon: "house.fill", color: .red, rotation: 10, degrees: degrees)
                WaypointView(title: "Tent", icon: "tent.fill", color: .green, rotation: 90, degrees: degrees)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .opacity(show ? 1 : 0)
            .blur(radius: show ? 0 : 20)
        }
        .foregroundColor(.white)
        .padding(40)
        .preferredColorScheme(.dark)
    }
    
    var arrow: some View {
        ZStack {
            Circle()
                .strokeBorder(.white.opacity(0.4), style: StrokeStyle(lineWidth: 5, dash: [1,2]))
            Circle()
                .strokeBorder(.white.opacity(0.4), style: StrokeStyle(lineWidth: 15, dash: [1,60]))
            Image("Arrow").rotationEffect(.degrees(degrees))
        }
        .frame(width: 93, height: 93)
    }
}

struct CompassSheet_Previews: PreviewProvider {
    static var previews: some View {
        CompassSheet(degrees: .constant(0), show: .constant(true))
            .ignoresSafeArea(edges: .bottom)
    }
}

struct InfoRow: View {
    var title: String
    var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased()).font(.caption)
                .opacity(0.5)
            Text(text)
        }
    }
}

struct WaypointView: View {
    var title = "Parked Car"
    var latitude = "35.08587 E"
    var longitude = "21.43573 W"
    var icon = "car.fill"
    var color = Color.blue
    var rotation: Double = 0
    var degrees: Double = 0
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.05))
                    .frame(width: 120)
                Circle()
                    .stroke(.linearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 120)
                    .overlay(
                        Circle().fill(color).frame(width: 28)
                            .overlay(Image(systemName: icon).font(.footnote).rotationEffect(.degrees(-degrees-rotation)))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    )
                Circle()
                    .fill(.white.opacity(0.02))
                    .frame(width: 80)
                Circle()
                    .stroke(.linearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 80)
                Circle()
                    .fill(.white.opacity(0.02))
                    .frame(width: 20)
                Circle()
                    .stroke(.linearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 20)
            }
            .rotationEffect(.degrees(degrees+rotation))
            
            VStack(spacing: 4) {
                Text(title)
                Text(latitude)
                    .font(.footnote).opacity(0.5)
                Text(longitude)
                    .font(.footnote).opacity(0.5)
            }
            .fontWeight(.medium)
            .foregroundColor(.white)
        }
    }
}
