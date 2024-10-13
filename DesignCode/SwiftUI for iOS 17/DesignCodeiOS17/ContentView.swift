//
//  ContentView.swift
//  DesignCodeiOS17
//
//  Created by mk on 2023/06/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "sparkles")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("modern architecture, an isometric tiny house, cute illustration, minimalist, vector art, night view")
                .font(.subheadline)
            HStack(spacing: 12.0) {
                VStack(alignment: .leading) {
                    Text("Size")
                        .foregroundColor(Color.secondary)
                    Text("1024x1024")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Type")
                        .foregroundColor(.secondary)
                    Text("Upscale")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Date")
                        .foregroundColor(.secondary)
                    Text("Today 5:19")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
            }
            .frame(height: 44.0)
        }
        .padding(20.0)
        .padding(.vertical, 20.0)
        .background(.green.gradient)
        .cornerRadius(20.0)
    }
}

#Preview {
    ContentView()
}
