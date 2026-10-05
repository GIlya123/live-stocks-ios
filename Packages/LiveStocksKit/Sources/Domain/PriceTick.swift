//
//  PriceTick.swift
//  Domain
//
//  Created by GIlya123 on 05.10.2026.
//

import Foundation

/// A single price update for one symbol
public struct PriceTick: Hashable, Sendable {
	public let ticker: String
	public let price: Decimal
	public let timestamp: Date

	public init(
		ticker: String,
		price: Decimal,
		timestamp: Date
	) {
		self.ticker = ticker
		self.price = price
		self.timestamp = timestamp
	}
}
