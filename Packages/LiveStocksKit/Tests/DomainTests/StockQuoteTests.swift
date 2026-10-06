//
//  StockQuoteTests.swift
//  DomainTests
//
//  Created by GIlya123 on 05.10.2026.
//

import Domain
import Foundation
import Testing

struct StockQuoteTests {
	@Test func startsAtOpenPriceWithNoChange() {
		// When
		let quote = StockQuote.fixture("AAPL", open: 100)

		// Then
		#expect(quote.price == 100)
		#expect(quote.change == 0)
		#expect(quote.changePercent == 0)
		#expect(quote.direction == .unchanged)
		#expect(quote.updatedAt == nil)
	}

	@Test func measuresChangeAgainstOpenPrice() {
		// Given
		var quote = StockQuote.fixture("AAPL", open: 200)

		// When
		quote.apply(.fixture("AAPL", price: 210, at: 1))
		quote.apply(.fixture("AAPL", price: 205, at: 2))

		// Then
		#expect(quote.change == 5)
		#expect(quote.changePercent == Decimal(string: "0.025"))
		#expect(quote.direction == .up)
	}

	@Test func ignoresTicksForOtherSymbols() {
		// Given
		var quote = StockQuote.fixture("AAPL", open: 100)

		// When
		let applied = quote.apply(.fixture("MSFT", price: 300, at: 1))

		// Then
		#expect(!applied)
		#expect(quote.price == 100)
	}

	@Test(arguments: [1.0, 0.5])
	func ignoresTicksThatAreNotNewer(than seconds: TimeInterval) {
		// Given
		var quote = StockQuote.fixture("AAPL", open: 100)
		quote.apply(.fixture("AAPL", price: 110, at: 1))

		// When
		let applied = quote.apply(.fixture("AAPL", price: 90, at: seconds))

		// Then
		#expect(!applied)
		#expect(quote.price == 110)
	}

	@Test func zeroOpenPriceDoesNotDivideByZero() {
		// Given
		var quote = StockQuote.fixture("AAPL", open: 0)

		// When
		quote.apply(.fixture("AAPL", price: 10, at: 1))

		// Then
		#expect(quote.changePercent == 0)
	}
}
