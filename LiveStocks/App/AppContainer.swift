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
	let region: Region
	let store: QuoteStore

	init(
		configuration: AppConfiguration,
		feed: any PriceStreaming
	) {
		region = configuration.region
		store = QuoteStore(
			quotes: configuration.quotes,
			feed: feed
		)
	}

	static func live(configuration: AppConfiguration) -> AppContainer {
		let feed = LivePriceFeed(
			url: configuration.priceFeedURL,
			openPrices: Dictionary(uniqueKeysWithValues: configuration.quotes.map { ($0.symbol.ticker, $0.openPrice) })
		)
		return AppContainer(
			configuration: configuration,
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
