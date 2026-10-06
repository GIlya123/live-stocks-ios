//
//  PriceChangeModelTests.swift
//  QuotesUITests
//
//  Created by GIlya123 on 06.10.2026.
//

import DesignSystem
import Domain
import DomainTesting
import Foundation
import QuotesUI
import Testing

struct PriceChangeModelTests {
	private let locale = Locale(identifier: "en_US")

	@Test func formatsRisingPrice() {
		// Given
		let quote = StockQuote.fixture("AAPL", open: 200, price: 202.5)

		// When
		let model = PriceChangeView.Model(quote, locale: locale)

		// Then
		#expect(model.price == "$202.50")
		#expect(model.change == "+1.25%")
		#expect(model.trend == .up)
	}

	@Test func formatsFallingPrice() {
		// Given
		let quote = StockQuote.fixture("AAPL", open: 200, price: 199)

		// When
		let model = PriceChangeView.Model(quote, locale: locale)

		// Then
		#expect(model.change == "-0.50%")
		#expect(model.trend == .down)
	}

	@Test func showsUnchangedPriceWithoutSign() {
		// Given
		let quote = StockQuote.fixture("AAPL", open: 200)

		// When
		let model = PriceChangeView.Model(quote, locale: locale)

		// Then
		#expect(model.change == "0.00%")
		#expect(model.trend == .flat)
	}

	@Test func showsChangeThatRoundsToZeroAsFlat() {
		// Given
		let quote = StockQuote.fixture("AAPL", open: 10_000, price: 9_999.99)

		// When
		let model = PriceChangeView.Model(quote, locale: locale)

		// Then
		#expect(model.change == "0.00%")
		#expect(model.trend == .flat)
	}
}
