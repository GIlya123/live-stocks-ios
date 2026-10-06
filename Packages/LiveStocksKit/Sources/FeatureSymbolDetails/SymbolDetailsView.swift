//
//  SymbolDetailsView.swift
//  FeatureSymbolDetails
//
//  Created by GIlya123 on 06.10.2026.
//

import DesignSystem
import Domain
import QuotesUI
import SwiftUI

/// Reads the same live quote as the list row, so the price updates here too
public struct SymbolDetailsView: View {
	private let liveQuote: LiveQuote

	@Environment(\.locale) private var locale

	public init(liveQuote: LiveQuote) {
		self.liveQuote = liveQuote
	}

	public var body: some View {
		List {
			Section {
				HStack {
					Text(liveQuote.quote.symbol.name)
						.font(.title3.weight(.semibold))
					Spacer()
					PriceChangeView(
						PriceChangeView.Model(
							liveQuote.quote,
							locale: locale
						)
					)
				}
				.padding(.vertical, Spacing.space8)
			}
			Section {
				Text(liveQuote.quote.symbol.summary)
			} header: {
				Text("About", bundle: .module)
			}
		}
		.navigationTitle(liveQuote.quote.symbol.ticker)
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	let store = QuoteStore(
		quotes: [
			StockQuote(
				symbol: StockSymbol(
					ticker: "AAPL",
					name: "Apple",
					summary: "Designs iPhone, Mac and services like the App Store.",
					currency: .usd
				),
				openPrice: 189
			)
		],
		feed: PreviewPriceFeed()
	)
	if let liveQuote = store.quotes.first {
		NavigationStack {
			SymbolDetailsView(liveQuote: liveQuote)
		}
	}
}
