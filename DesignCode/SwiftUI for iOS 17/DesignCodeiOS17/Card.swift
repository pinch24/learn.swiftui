//
//  Card.swift
//  DesignCodeiOS17
//
//  Created by MK on 10/21/24.
//

import SwiftUI

struct Card: Identifiable {
	var id = UUID()
	var title: String
	var text: String
	var image: Image
}

var cards = [
	Card(title: "3D House", text: "modern architecture, an isometric tiny house, cute illustration, minimalist, vector art, sunset view --q 2 --v 5.1", image: Image(.image1)),
	Card(title: "Sunset", text: "modern architecture, an isometric tiny house, cute illustration, minimalist, vector art, sunset view --q 2 --v 5.1", image: Image(.image2)),
	Card(title: "Sunrise", text: "modern architecture, an isometric tiny house, cute illustration, minimalist, vector art, sunset view --q 2 --v 5.1", image: Image(.image3)),
	Card(title: "Blue Hour", text: "modern architecture, an isometric tiny house, cute illustration, minimalist, vector art, sunset view --q 2 --v 5.1", image: Image(.image4)),
	Card(title: "Night", text: "modern architecture, an isometric tiny house, cute illustration, minimalist, vector art, sunset view --q 2 --v 5.1", image: Image(.image5)),
	Card(title: "Morning", text: "modern architecture, an isometric tiny house, cute illustration, minimalist, vector art, sunset view --q 2 --v 5.1", image: Image(.image6)),
	Card(title: "Day", text: "modern architecture, an isometric tiny house, cute illustration, minimalist, vector art, sunset view --q 2 --v 5.1", image: Image(.image7))
]
