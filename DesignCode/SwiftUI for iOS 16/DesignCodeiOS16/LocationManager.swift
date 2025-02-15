//
//  LocationManager.swift
//  DesignCodeiOS16
//
//  Created by MK on 10/23/24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	let manager = CLLocationManager()
	@Published var degrees: Double = 0
	@Published var location: CLLocationCoordinate2D?
	
	override init() {
		super.init()
		manager.delegate = self
		manager.startUpdatingHeading()
		manager.requestWhenInUseAuthorization()
		manager.startUpdatingLocation()
	}
	
	func requestLocation() {
		manager.requestLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		degrees = newHeading.trueHeading
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		location = locations.first?.coordinate
	}
}

func compassDirection(_ degrees: Double) -> String {
	let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
	let index = Int((degrees + 22.5) / 45.0) & 7
	return directions[index]
}
