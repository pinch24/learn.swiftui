//
//  Currency.swift
//  LOTRConverter17
//
//  Created by MK on 10/18/24.
//

import SwiftUI

enum Currency: Double, CaseIterable, Identifiable {
	case copperPenny = 6400
	case silverPenny = 64
	case silverPiece = 16
	case goldPenny = 4
	case goldPiece = 1
	
	var id: Currency { self }
	
	var image: ImageResource {
		switch self {
			case .copperPenny:
					.copperpenny
			case .silverPenny:
					.silverpenny
			case .silverPiece:
					.silverpiece
			case .goldPenny:
					.goldpenny
			case .goldPiece:
					.goldpiece
		}
	}
	
	var name: String {
		switch self {
			case .copperPenny:
				return "Copper Penny"
			case .silverPenny:
				return "Silver Penny"
			case .silverPiece:
				return "Silver Piece"
			case .goldPenny:
				return "Gold Penny"
			case .goldPiece:
				return "Gold Piece"
		}
	}
	
	func convert(_ amountString: String, to currency: Currency) -> String {
		guard let amount = Double(amountString) else {
			return ""
		}
		
		let value = (amount / self.rawValue) * currency.rawValue
		return String(format: "%.2f", value)
	}
}
