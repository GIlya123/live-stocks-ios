//
//  Decimal+Rounding.swift
//  PriceFeed
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

extension Decimal {
	/// Rounds half away from zero to the given number of fraction digits, 2 gives cents
	func rounded(scale: Int) -> Decimal {
		var value = self
		var result = Decimal()
		NSDecimalRound(&result, &value, scale, .plain)
		return result
	}
}
