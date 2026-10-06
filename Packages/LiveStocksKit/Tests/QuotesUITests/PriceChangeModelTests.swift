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

	@Test func formatsPriceInSymbolCurrency() {
		// Given
		let quote = StockQuote.fixture("EMAAR", open: 9.1, currency: .aed)

		// When
		let model = PriceChangeView.Model(quote, locale: locale)

		// Then
		// The formatter puts a non-breaking space between the code and the amount
		#expect(model.price.contains("AED"))
		#expect(model.price.contains("9.10"))
	}

	@Test func keepsLatinDigitsInArabic() {
		// Given
		let quote = StockQuote.fixture("EMAAR", open: 9.1, currency: .aed)
		let arabicIndicDigits = Set("٠١٢٣٤٥٦٧٨٩")

		// When
		let model = PriceChangeView.Model(quote, locale: Locale(identifier: "ar_AE"))

		// Then
		#expect(model.price.contains("9"))
		#expect(!model.price.contains { arabicIndicDigits.contains($0) })
	}
}
