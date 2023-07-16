//
//  MyMapView.swift
//  MapTutorial
//
//  Created by mk on 2023/07/16.
//

import SwiftUI
import MapKit
import CoreLocation

struct MyMapView: UIViewRepresentable {
	
	let locationManager = CLLocationManager()
	
	func makeUIView(context: Context) -> MKMapView {
		
		locationManager.delegate = context.coordinator
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		
		let mkMapView = MKMapView()
		mkMapView.delegate = context.coordinator
		mkMapView.showsUserLocation = true
		mkMapView.setUserTrackingMode(.follow, animated: true)
		
		let regionRadius: CLLocationDistance = 200
		let coordinateRegion = MKCoordinateRegion(center: mkMapView.userLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		mkMapView.setRegion(coordinateRegion, animated: true)
		
		return mkMapView
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		
	}
	
	func makeCoordinator() -> MyMapView.Coordinator {
		return MyMapView.Coordinator(myMapView: self)
	}
	
	class Coordinator: NSObject {
		
		var myMapView: MyMapView
		
		init(myMapView: MyMapView) {
			self.myMapView = myMapView
		}
	}
}

extension MyMapView.Coordinator : MKMapViewDelegate {
	
}

extension MyMapView.Coordinator : CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let _ = locations.first?.coordinate.latitude,
			  let _ = locations.first?.coordinate.longitude
		else { return }
	}
}
