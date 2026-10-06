//
//  Fixtures.swift
//  DomainTesting
//
//  Created by GIlya123 on 05.10.2026.
//

import Domain
import Foundation

extension StockSymbol {
	public static func fixture(
		_ ticker: String,
		currency: Currency = .usd
	) -> StockSymbol {
		StockSymbol(
			ticker: ticker,
			name: "\(ticker) Inc.",
			summary: "\(ticker) summary",
			currency: currency
		)
	}
}

extension StockQuote {
	public static func fixture(
		_ ticker: String,
		open: Decimal,
		price: Decimal? = nil,
		currency: Currency = .usd
	) -> StockQuote {
		var quote = StockQuote(
			symbol: .fixture(
				ticker,
				currency: currency
			),
			openPrice: open
		)
		if let price {
			quote.apply(.fixture(ticker, price: price, sequence: 1))
		}
		return quote
	}
}

extension PriceTick {
	public static func fixture(
		_ ticker: String,
		price: Decimal,
		sequence: Int
	) -> PriceTick {
		PriceTick(
			ticker: ticker,
			price: price,
			sequence: sequence,
			timestamp: Date(timeIntervalSince1970: TimeInterval(sequence))
		)
	}
}
