//
//  PriceMessage.swift
//  PriceFeed
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation

/// Wire format of a tick, price is a string since JSONDecoder reads Decimal through Double
struct PriceMessage: Codable, Equatable {
	let ticker: String
	let price: String
	let sequence: Int
	let timestamp: Date
}

extension PriceMessage {
	init(_ tick: PriceTick) {
		self.init(
			ticker: tick.ticker,
			price: tick.price.description,
			sequence: tick.sequence,
			timestamp: tick.timestamp
		)
	}

	/// Nil when the price isn't a number
	var tick: PriceTick? {
		guard let price = Decimal(string: price) else {
			return nil
		}

		return PriceTick(
			ticker: ticker,
			price: price,
			sequence: sequence,
			timestamp: timestamp
		)
	}
}
