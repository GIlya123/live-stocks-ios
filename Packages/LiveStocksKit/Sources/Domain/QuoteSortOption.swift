//
//  QuoteSortOption.swift
//  Domain
//
//  Created by GIlya123 on 05.10.2026.
//

import Foundation

public enum QuoteSortOption: CaseIterable, Sendable {
	/// By current price
	case price
	/// By change since open in percent
	case priceChange
}

extension QuoteSortOption {
	fileprivate func value(of quote: StockQuote) -> Decimal {
		switch self {
		case .price:
			quote.price
		case .priceChange:
			quote.changePercent
		}
	}
}

extension Sequence where Element == StockQuote {
	/// Highest first, ties are ordered by ticker
	public func sorted(by option: QuoteSortOption) -> [StockQuote] {
		sorted { lhs, rhs in
			let lhsValue = option.value(of: lhs)
			let rhsValue = option.value(of: rhs)

			guard lhsValue == rhsValue else {
				return lhsValue > rhsValue
			}

			return lhs.symbol.ticker < rhs.symbol.ticker
		}
	}
}
