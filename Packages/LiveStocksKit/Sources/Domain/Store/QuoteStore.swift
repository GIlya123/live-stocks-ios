//
//  QuoteStore.swift
//  Domain
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation
import Observation

/// Live quotes shared by all screens, fed by a price stream
@MainActor
@Observable
public final class QuoteStore {
	/// In catalog order
	public let quotes: [LiveQuote]
	public private(set) var connectionState = ConnectionState.disconnected

	private let feed: any PriceStreaming
	private let quotesByTicker: [String: LiveQuote]

	public init(
		quotes: [StockQuote],
		feed: any PriceStreaming
	) {
		self.quotes = quotes.map(LiveQuote.init)
		self.quotesByTicker = Dictionary(uniqueKeysWithValues: self.quotes.map { ($0.id, $0) })
		self.feed = feed
	}

	public func liveQuote(for symbol: StockSymbol) -> LiveQuote? {
		quotesByTicker[symbol.ticker]
	}

	/// Applies feed updates until the calling task is cancelled
	public func listen() async {
		for await update in await feed.updates() {
			switch update {
			case .state(let state):
				connectionState = state
			case .tick(let tick):
				quotesByTicker[tick.ticker]?.apply(tick)
			}
		}
	}

	public func start() async {
		await feed.start()
	}

	public func stop() async {
		await feed.stop()
	}
}
