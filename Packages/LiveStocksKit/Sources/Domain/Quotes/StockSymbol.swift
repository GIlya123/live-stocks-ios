//
//  StockSymbol.swift
//  Domain
//
//  Created by GIlya123 on 05.10.2026.
//

public struct StockSymbol: Hashable, Identifiable, Sendable {
	public let ticker: String
	public let name: String
	/// Short stock description
	public let summary: String

	public var id: String {
		ticker
	}

	public init(
		ticker: String,
		name: String,
		summary: String
	) {
		self.ticker = ticker
		self.name = name
		self.summary = summary
	}
}
