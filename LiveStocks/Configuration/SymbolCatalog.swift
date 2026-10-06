//
//  SymbolCatalog.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation

/// Symbols each region tracks with their session open prices
enum SymbolCatalog {
	struct Entry {
		let ticker: String
		let name: String
		let openPrice: String
		let summary: String
	}

	static func quotes(for region: Region) -> [StockQuote] {
		switch region {
		case .unitedStates:
			quotes(
				from: unitedStates,
				currency: .usd
			)
		case .unitedArabEmirates:
			quotes(
				from: unitedArabEmirates,
				currency: .aed
			)
		}
	}

	private static func quotes(
		from entries: [Entry],
		currency: Currency
	) -> [StockQuote] {
		entries.map { entry in
			guard let openPrice = Decimal(string: entry.openPrice) else {
				preconditionFailure("Invalid open price in catalog: \(entry.openPrice)")
			}

			return StockQuote(
				symbol: StockSymbol(
					ticker: entry.ticker,
					name: entry.name,
					summary: entry.summary,
					currency: currency
				),
				openPrice: openPrice
			)
		}
	}
}
