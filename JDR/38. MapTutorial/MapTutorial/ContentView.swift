//
//  ContentView.swift
//  MapTutorial
//
//  Created by mk on 2023/07/16.
//

import SwiftUI
import MapKit

struct ContentView: View {
	@State var myPosition = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(37.5039018), longitude: CLLocationDegrees(127.0047481)), span: MKCoordinateSpan())
	
    var body: some View {
        //Map(coordinateRegion: $myPosition)	// iOS 14+
		MyMapView()								// iOS 13
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
