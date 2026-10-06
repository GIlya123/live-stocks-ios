//
//  Fixtures.swift
//  DomainTests
//
//  Created by GIlya123 on 05.10.2026.
//

import Domain
import Foundation

extension StockSymbol {
	static func fixture(_ ticker: String) -> StockSymbol {
		StockSymbol(
			ticker: ticker,
			name: "\(ticker) Inc."
		)
	}
}

extension StockQuote {
	static func fixture(
		_ ticker: String,
		open: Decimal,
		price: Decimal? = nil
	) -> StockQuote {
		var quote = StockQuote(
			symbol: .fixture(ticker),
			openPrice: open
		)
		if let price {
			quote.apply(.fixture(ticker, price: price, at: 1))
		}
		return quote
	}
}

extension PriceTick {
	static func fixture(
		_ ticker: String,
		price: Decimal,
		at seconds: TimeInterval
	) -> PriceTick {
		PriceTick(
			ticker: ticker,
			price: price,
			timestamp: Date(timeIntervalSince1970: seconds)
		)
	}
}
