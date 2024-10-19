//
//  CurrencyTip.swift
//  LOTRConverter17
//
//  Created by MK on 10/19/24.
//

import Foundation
import TipKit

struct CurrencyTip: Tip {
	let title = Text("Change Currency")
	
	var message: Text? = Text("You can tap the left or right currency to bring up the Select Currency screen.")
}
