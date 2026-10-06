//
//  StockQuote.swift
//  Domain
//
//  Created by GIlya123 on 05.10.2026.
//

import Foundation

public struct StockQuote: Hashable, Identifiable, Sendable {
	public let symbol: StockSymbol
	/// Session open price, change is measured against it
	public let openPrice: Decimal
	public private(set) var price: Decimal
	public private(set) var updatedAt: Date?
	private var lastSequence: Int?

	public var id: String {
		symbol.id
	}

	public init(
		symbol: StockSymbol,
		openPrice: Decimal
	) {
		self.symbol = symbol
		self.openPrice = openPrice
		self.price = openPrice
	}

	public var change: Decimal {
		price - openPrice
	}

	/// Fraction, e.g. 0.0125 for +1.25%
	public var changePercent: Decimal {
		guard openPrice != 0 else { return 0 }
		return change / openPrice
	}

	public var direction: PriceDirection {
		PriceDirection(from: openPrice, to: price)
	}

	/// Returns false if the tick is for another symbol or isn't newer than the last one
	@discardableResult
	public mutating func apply(_ tick: PriceTick) -> Bool {
		guard tick.ticker == symbol.ticker else {
			return false
		}

		guard tick.sequence > lastSequence ?? .min else {
			return false
		}

		price = tick.price
		updatedAt = tick.timestamp
		lastSequence = tick.sequence
		return true
	}
}
