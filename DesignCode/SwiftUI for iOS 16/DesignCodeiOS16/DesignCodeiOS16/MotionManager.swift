//
//  MotionManager.swift
//  DesignCodeiOS16
//
//  Created by mk on 11/5/23.
//

import CoreMotion

class MotionManager: ObservableObject {
	@Published var pitch: Double = 0.0
	@Published var roll: Double = 0.0
	@Published var rotation: Double = 0.0
	
	var motion: CMMotionManager
	
	init() {
		motion = CMMotionManager()
		motion.deviceMotionUpdateInterval = 1 / 60
		motion.startDeviceMotionUpdates(to: .main) { motionData, error in
			guard error == nil else { return }
			
			if let motionData = motionData {
				self.pitch = motionData.attitude.pitch
				self.roll = motionData.attitude.roll
				self.rotation = motionData.rotationRate.x
			}
		}
	}
}
