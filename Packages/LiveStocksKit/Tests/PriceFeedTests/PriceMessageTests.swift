//
//  PriceMessageTests.swift
//  PriceFeedTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation
import Networking
import Testing

@testable import PriceFeed

struct PriceMessageTests {
	private let serializer = MessageSerializer()

	@Test func roundTripKeepsExactPrice() throws {
		// Given
		let tick = PriceTick(
			ticker: "AAPL",
			price: try #require(Decimal(string: "189.27")),
			sequence: 7,
			timestamp: Date(timeIntervalSince1970: 1_000)
		)

		// When
		let text = try serializer.encode(PriceMessage(tick))
		let decoded = try serializer.decode(PriceMessage.self, from: text).tick

		// Then
		#expect(decoded == tick)
	}

	@Test func encodesPriceAsString() throws {
		// Given
		let tick = PriceTick(
			ticker: "AAPL",
			price: try #require(Decimal(string: "0.1")),
			sequence: 1,
			timestamp: Date(timeIntervalSince1970: 0)
		)

		// When
		let text = try serializer.encode(PriceMessage(tick))

		// Then
		#expect(text.contains(#""price":"0.1""#))
	}

	@Test func ignoresPriceThatIsNotANumber() {
		// Given
		let message = PriceMessage(
			ticker: "AAPL",
			price: "abc",
			sequence: 1,
			timestamp: Date(timeIntervalSince1970: 0)
		)

		// When
		let tick = message.tick

		// Then
		#expect(tick == nil)
	}
}
