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
		/// Cents or fils keep the price exact, a Decimal from a float literal goes through Double
		let openPriceInMinorUnits: Int
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
			StockQuote(
				symbol: StockSymbol(
					ticker: entry.ticker,
					name: entry.name,
					summary: entry.summary,
					currency: currency
				),
				openPrice: Decimal(entry.openPriceInMinorUnits) / 100
			)
		}
	}
}
