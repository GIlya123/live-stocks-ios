//
//  PriceDirectionTests.swift
//  DomainTests
//
//  Created by GIlya123 on 05.10.2026.
//

import Domain
import Foundation
import Testing

struct PriceDirectionTests {
	@Test(arguments: [
		(Decimal(10), Decimal(11), PriceDirection.up),
		(Decimal(10), Decimal(9), PriceDirection.down),
		(Decimal(10), Decimal(10), PriceDirection.unchanged),
	])
	func comparesPrices(old: Decimal, new: Decimal, expected: PriceDirection) {
		#expect(PriceDirection(from: old, to: new) == expected)
	}
}
