//
//  PriceDirection.swift
//  Domain
//
//  Created by GIlya123 on 05.10.2026.
//

import Foundation

public enum PriceDirection: Sendable {
	case up
	case down
	case unchanged

	public init(
		from oldPrice: Decimal,
		to newPrice: Decimal
	) {
		if newPrice > oldPrice {
			self = .up
		} else if newPrice < oldPrice {
			self = .down
		} else {
			self = .unchanged
		}
	}
}
