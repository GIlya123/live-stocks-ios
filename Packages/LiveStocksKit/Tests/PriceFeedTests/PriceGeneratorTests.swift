//
//  PriceGeneratorTests.swift
//  PriceFeedTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation
import Testing

@testable import PriceFeed

struct PriceGeneratorTests {
	@Test func movesPriceByAtMostOnePercentAndRoundsToCents() throws {
		// Given
		var generator = PriceGenerator(startPrices: ["AAPL": 100])
		var previous: Decimal = 100
		let maxStep = try #require(Decimal(string: "0.01"))
		let roundingSlack = try #require(Decimal(string: "0.005"))

		for _ in 0..<100 {
			// When
			let price = generator.nextPrice(for: "AAPL")

			// Then
			#expect(abs(price - previous) <= previous * maxStep + roundingSlack)
			#expect(price == price.rounded(scale: 2))
			previous = price
		}
	}

	@Test func neverDropsBelowOneCent() throws {
		// Given
		let cent = try #require(Decimal(string: "0.01"))
		var generator = PriceGenerator(startPrices: ["PENNY": cent])

		// When
		let prices = (0..<200).map { _ in generator.nextPrice(for: "PENNY") }

		// Then
		#expect(prices.allSatisfy { $0 >= cent })
	}

	@Test func listsTickersInStableOrder() {
		// When
		let generator = PriceGenerator(startPrices: ["MSFT": 1, "AAPL": 1, "NVDA": 1])

		// Then
		#expect(generator.tickers == ["AAPL", "MSFT", "NVDA"])
	}
}
