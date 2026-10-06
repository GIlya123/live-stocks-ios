//
//  SymbolCatalog.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation

/// Symbols the app tracks with their session open prices
enum SymbolCatalog {
	private struct Entry {
		let ticker: String
		let name: String
		/// Cents keep the price exact, a Decimal from a float literal goes through Double
		let openPriceInCents: Int
	}

	private static let entries = [
		Entry(ticker: "AAPL", name: "Apple", openPriceInCents: 227_48),
		Entry(ticker: "MSFT", name: "Microsoft", openPriceInCents: 428_15),
		Entry(ticker: "NVDA", name: "NVIDIA", openPriceInCents: 124_92),
		Entry(ticker: "GOOG", name: "Alphabet", openPriceInCents: 168_90),
		Entry(ticker: "AMZN", name: "Amazon", openPriceInCents: 186_51),
		Entry(ticker: "META", name: "Meta Platforms", openPriceInCents: 582_77),
		Entry(ticker: "TSLA", name: "Tesla", openPriceInCents: 250_08),
		Entry(ticker: "AVGO", name: "Broadcom", openPriceInCents: 172_50),
		Entry(ticker: "JPM", name: "JPMorgan Chase", openPriceInCents: 211_63),
		Entry(ticker: "V", name: "Visa", openPriceInCents: 279_12),
		Entry(ticker: "MA", name: "Mastercard", openPriceInCents: 497_30),
		Entry(ticker: "UNH", name: "UnitedHealth", openPriceInCents: 584_02),
		Entry(ticker: "XOM", name: "Exxon Mobil", openPriceInCents: 118_74),
		Entry(ticker: "JNJ", name: "Johnson & Johnson", openPriceInCents: 161_19),
		Entry(ticker: "WMT", name: "Walmart", openPriceInCents: 80_43),
		Entry(ticker: "PG", name: "Procter & Gamble", openPriceInCents: 172_05),
		Entry(ticker: "HD", name: "Home Depot", openPriceInCents: 406_88),
		Entry(ticker: "COST", name: "Costco", openPriceInCents: 887_60),
		Entry(ticker: "NFLX", name: "Netflix", openPriceInCents: 710_34),
		Entry(ticker: "AMD", name: "Advanced Micro Devices", openPriceInCents: 165_80),
		Entry(ticker: "ORCL", name: "Oracle", openPriceInCents: 170_47),
		Entry(ticker: "CRM", name: "Salesforce", openPriceInCents: 284_06),
		Entry(ticker: "ADBE", name: "Adobe", openPriceInCents: 517_68),
		Entry(ticker: "INTC", name: "Intel", openPriceInCents: 22_39),
		Entry(ticker: "DIS", name: "Walt Disney", openPriceInCents: 94_25),
	]

	static let quotes = entries.map { entry in
		StockQuote(
			symbol: StockSymbol(
				ticker: entry.ticker,
				name: entry.name
			),
			openPrice: Decimal(entry.openPriceInCents) / 100
		)
	}
}
