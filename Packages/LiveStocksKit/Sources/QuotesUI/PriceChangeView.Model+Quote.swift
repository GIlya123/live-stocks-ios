//
//  PriceChangeView.Model+Quote.swift
//  QuotesUI
//
//  Created by GIlya123 on 06.10.2026.
//

import DesignSystem
import Domain
import Foundation

private enum Constants {
	/// Changes below this round to 0.00% on screen, so they show as flat
	static let minVisibleChange = Decimal(sign: .plus, exponent: -5, significand: 5)
}

extension PriceChangeView.Model {
	public init(
		_ quote: StockQuote,
		locale: Locale
	) {
		self.init(
			price: quote.price.formatted(.currency(code: "USD").locale(locale)),
			change: quote.changePercent.formatted(
				.percent
					.precision(.fractionLength(2))
					.sign(strategy: .always(includingZero: false))
					.locale(locale)
			),
			trend: abs(quote.changePercent) < Constants.minVisibleChange ? .flat : Trend(quote.direction)
		)
	}
}

extension PriceChangeView.Model.Trend {
	fileprivate init(_ direction: PriceDirection) {
		switch direction {
		case .up:
			self = .up
		case .down:
			self = .down
		case .unchanged:
			self = .flat
		}
	}
}
