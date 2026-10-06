//
//  SymbolCatalogTests.swift
//  LiveStocksTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Testing

@testable import LiveStocks

@MainActor
struct SymbolCatalogTests {
	@Test(arguments: Region.allCases)
	func hasTwentyFiveUniqueSymbols(region: Region) {
		// When
		let tickers = SymbolCatalog.quotes(for: region).map(\.symbol.ticker)

		// Then
		#expect(tickers.count == 25)
		#expect(Set(tickers).count == tickers.count)
	}

	@Test(arguments: [
		(Region.unitedStates, Currency.usd),
		(.unitedArabEmirates, .aed),
	])
	func pricesSymbolsInRegionCurrency(region: Region, currency: Currency) {
		#expect(SymbolCatalog.quotes(for: region).allSatisfy { $0.symbol.currency == currency })
	}
}
