//
//  Game.swift
//  RGBullsEye
//
//  Created by mk on 12/10/23.
//

import Foundation

struct Game {
	let start = RGB()
	var target = RGB.random()
	var round = 1
	var scoreRound = 0
	var scoreTotal = 0
	
	/// Check the guess values of an RGB object against a target RGB object.
	/// Compute the score out of 100. Add bonus points to very high scores.
	///   - parameters:
	///     - guess: The RGB object with guess values.
	mutating func check(guess: RGB) {
		let difference = lround(guess.difference(target: target) * 100.0)
		scoreRound = 100 - difference
		if difference == 0 {
			scoreRound += 100
		} else if difference == 1 { scoreRound += 50 }
		scoreTotal += scoreRound
	}
	
	/// Start a new round with a random RGB target object.
	mutating func startNewRound() {
		round += 1
		scoreRound = 0
		target = RGB.random()
	}
	
	/// Start a new game: Reset total score to 0.
	mutating func startNewGame() {
		round = 0
		scoreTotal = 0
		startNewRound()
	}
}
