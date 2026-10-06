//
//  QuoteSortingTests.swift
//  DomainTests
//
//  Created by GIlya123 on 05.10.2026.
//

import Domain
import Testing

struct QuoteSortingTests {
	private let quotes: [StockQuote] = [
		.fixture("AAPL", open: 100, price: 110),
		.fixture("NVDA", open: 800, price: 760),
		.fixture("TSLA", open: 200, price: 230),
	]

	@Test func sortsByPriceHighestFirst() {
		// When
		let tickers = quotes.sorted(by: .price).map(\.symbol.ticker)

		// Then
		#expect(tickers == ["NVDA", "TSLA", "AAPL"])
	}

	@Test func sortsByPercentChangeHighestFirst() {
		// When
		let tickers = quotes.sorted(by: .priceChange).map(\.symbol.ticker)

		// Then
		#expect(tickers == ["TSLA", "AAPL", "NVDA"])
	}

	@Test(arguments: QuoteSortOption.allCases)
	func ordersEqualValuesByTicker(option: QuoteSortOption) {
		// Given
		let equal: [StockQuote] = [
			.fixture("MSFT", open: 100, price: 100),
			.fixture("AMZN", open: 100, price: 100),
			.fixture("GOOG", open: 100, price: 100),
		]

		// When
		let tickers = equal.sorted(by: option).map(\.symbol.ticker)

		// Then
		#expect(tickers == ["AMZN", "GOOG", "MSFT"])
	}
}
