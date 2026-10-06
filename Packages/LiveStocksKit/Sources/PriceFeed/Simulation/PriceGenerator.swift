//
//  PriceGenerator.swift
//  PriceFeed
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

/// Simulates the market for the echo server: random walk, each step moves a price by up to 1%
struct PriceGenerator {
	private enum Constants {
		static let maxStep = 0.01
		static let minPrice: Decimal = 0.01
		static let scale = 2
	}

	private var prices: [String: Decimal]

	init(openPrices: [String: Decimal]) {
		prices = openPrices
	}

	var tickers: [String] {
		prices.keys.sorted()
	}

	mutating func nextPrice(for ticker: String) -> Decimal {
		let current = prices[ticker] ?? Constants.minPrice
		let step = Double.random(in: -Constants.maxStep...Constants.maxStep)
		let next = max(
			(current * Decimal(1 + step)).rounded(scale: Constants.scale),
			Constants.minPrice
		)
		prices[ticker] = next
		return next
	}
}
