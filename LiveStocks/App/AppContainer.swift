//
//  AppContainer.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import FeatureSymbolDetails
import FeatureSymbolsList
import Foundation
import PriceFeed

/// Builds the app's long-lived objects, the only place that knows concrete types
final class AppContainer {
	let store: QuoteStore

	init(configuration: AppConfiguration = .current) {
		let quotes = SymbolCatalog.quotes
		let feed = LivePriceFeed(
			url: configuration.priceFeedURL,
			startPrices: Dictionary(uniqueKeysWithValues: quotes.map { ($0.symbol.ticker, $0.openPrice) })
		)
		store = QuoteStore(
			quotes: quotes,
			feed: feed
		)
	}

	func makeSymbolsListViewModel() -> SymbolsListViewModel {
		SymbolsListViewModel(store: store)
	}

	func makeSymbolDetailsView(for symbol: StockSymbol) -> SymbolDetailsView? {
		store.liveQuote(for: symbol).map(SymbolDetailsView.init)
	}
}
