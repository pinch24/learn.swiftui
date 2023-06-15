//
//  OnBoardingItem.swift
//  AnimatedOnBoardingScreen
//
//  Created by mk on 2023/01/01.
//

import SwiftUI
import Lottie

// MARK: OnBoarding Item Model
struct OnBoardingItem: Identifiable, Equatable {
	var id: UUID = .init()
	var title: String
	var subTitle: String
	var lottieView: LottieAnimationView = .init()
}
