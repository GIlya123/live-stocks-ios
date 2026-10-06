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
		let summary: String
	}

	private static let entries = [
		Entry(
			ticker: "AAPL",
			name: "Apple",
			openPriceInCents: 227_48,
			summary: "Designs the iPhone, Mac and Apple Watch and runs services like the App Store and iCloud."
		),
		Entry(
			ticker: "MSFT",
			name: "Microsoft",
			openPriceInCents: 428_15,
			summary: "Makes Windows and Office and runs the Azure cloud platform."
		),
		Entry(
			ticker: "NVDA",
			name: "NVIDIA",
			openPriceInCents: 124_92,
			summary: "Designs graphics processors that power gaming and most AI data centers."
		),
		Entry(
			ticker: "GOOG",
			name: "Alphabet",
			openPriceInCents: 168_90,
			summary: "Parent of Google, earning mostly from search and YouTube advertising and Google Cloud."
		),
		Entry(
			ticker: "AMZN",
			name: "Amazon",
			openPriceInCents: 186_51,
			summary: "Runs the largest online store in the US and the AWS cloud platform."
		),
		Entry(
			ticker: "META",
			name: "Meta Platforms",
			openPriceInCents: 582_77,
			summary: "Owns Facebook, Instagram and WhatsApp and earns mostly from advertising."
		),
		Entry(
			ticker: "TSLA",
			name: "Tesla",
			openPriceInCents: 250_08,
			summary: "Builds electric cars, batteries and solar products."
		),
		Entry(
			ticker: "AVGO",
			name: "Broadcom",
			openPriceInCents: 172_50,
			summary: "Makes networking and custom chips and sells infrastructure software."
		),
		Entry(
			ticker: "JPM",
			name: "JPMorgan Chase",
			openPriceInCents: 211_63,
			summary: "Largest US bank by assets, covering retail, investment banking and asset management."
		),
		Entry(
			ticker: "V",
			name: "Visa",
			openPriceInCents: 279_12,
			summary: "Runs a global card payments network that processes transactions for banks."
		),
		Entry(
			ticker: "MA",
			name: "Mastercard",
			openPriceInCents: 497_30,
			summary: "Runs a global card payments network and related data services."
		),
		Entry(
			ticker: "UNH",
			name: "UnitedHealth",
			openPriceInCents: 584_02,
			summary: "Largest US health insurer, also running pharmacy and care services."
		),
		Entry(
			ticker: "XOM",
			name: "Exxon Mobil",
			openPriceInCents: 118_74,
			summary: "Produces and refines oil and natural gas worldwide."
		),
		Entry(
			ticker: "JNJ",
			name: "Johnson & Johnson",
			openPriceInCents: 161_19,
			summary: "Develops prescription drugs and medical devices."
		),
		Entry(
			ticker: "WMT",
			name: "Walmart",
			openPriceInCents: 80_43,
			summary: "Runs the largest chain of discount stores and supermarkets in the US."
		),
		Entry(
			ticker: "PG",
			name: "Procter & Gamble",
			openPriceInCents: 172_05,
			summary: "Makes household brands like Tide, Pampers and Gillette."
		),
		Entry(
			ticker: "HD",
			name: "Home Depot",
			openPriceInCents: 406_88,
			summary: "Largest home improvement retailer in the US."
		),
		Entry(
			ticker: "COST",
			name: "Costco",
			openPriceInCents: 887_60,
			summary: "Runs membership warehouse stores selling goods in bulk."
		),
		Entry(
			ticker: "NFLX",
			name: "Netflix",
			openPriceInCents: 710_34,
			summary: "Streams films and series to subscribers in over 190 countries."
		),
		Entry(
			ticker: "AMD",
			name: "Advanced Micro Devices",
			openPriceInCents: 165_80,
			summary: "Designs processors and graphics chips for PCs, consoles and data centers."
		),
		Entry(
			ticker: "ORCL",
			name: "Oracle",
			openPriceInCents: 170_47,
			summary: "Sells database software, business applications and cloud infrastructure."
		),
		Entry(
			ticker: "CRM",
			name: "Salesforce",
			openPriceInCents: 284_06,
			summary: "Leading provider of cloud software for sales, service and marketing teams."
		),
		Entry(
			ticker: "ADBE",
			name: "Adobe",
			openPriceInCents: 517_68,
			summary: "Makes creative software like Photoshop and Acrobat, sold by subscription."
		),
		Entry(
			ticker: "INTC",
			name: "Intel",
			openPriceInCents: 22_39,
			summary: "Designs and manufactures processors for PCs and servers."
		),
		Entry(
			ticker: "DIS",
			name: "Walt Disney",
			openPriceInCents: 94_25,
			summary: "Runs film studios, theme parks and streaming services like Disney+."
		),
	]

	static let quotes = entries.map { entry in
		StockQuote(
			symbol: StockSymbol(
				ticker: entry.ticker,
				name: entry.name,
				summary: entry.summary,
				currency: .usd
			),
			openPrice: Decimal(entry.openPriceInCents) / 100
		)
	}
}
