//
//  SymbolsListView.swift
//  FeatureSymbolsList
//
//  Created by GIlya123 on 06.10.2026.
//

import DesignSystem
import Domain
import QuotesUI
import SwiftUI

public struct SymbolsListView: View {
	@Bindable private var viewModel: SymbolsListViewModel

	public init(viewModel: SymbolsListViewModel) {
		self.viewModel = viewModel
	}

	public var body: some View {
		List(viewModel.rows) { liveQuote in
			SymbolRow(liveQuote: liveQuote)
		}
		.listStyle(.plain)
		.safeAreaInset(edge: .top) {
			header
		}
		.animation(
			.default,
			value: viewModel.rows.map(\.id)
		)
		.navigationTitle("Stocks")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(viewModel.isRunning ? "Stop" : "Start") {
					Task {
						await viewModel.toggleFeed()
					}
				}
			}
		}
		.task {
			await viewModel.keepSorted()
		}
	}

	private var header: some View {
		VStack(
			alignment: .leading,
			spacing: Spacing.space8
		) {
			ConnectionStatusView(state: viewModel.connectionState)
			Picker(
				"Sort",
				selection: $viewModel.sortOption
			) {
				Text("Price")
					.tag(QuoteSortOption.price)
				Text("Change")
					.tag(QuoteSortOption.priceChange)
			}
			.pickerStyle(.segmented)
		}
		.padding(.horizontal, Spacing.space16)
		.padding(.bottom, Spacing.space8)
		.background(.background)
	}
}

#Preview {
	let store = QuoteStore(
		quotes: [
			StockQuote(
				symbol: StockSymbol(
					ticker: "AAPL",
					name: "Apple"
				),
				openPrice: 189
			),
			StockQuote(
				symbol: StockSymbol(
					ticker: "NVDA",
					name: "NVIDIA"
				),
				openPrice: 121
			),
		],
		feed: PreviewPriceFeed()
	)
	NavigationStack {
		SymbolsListView(viewModel: SymbolsListViewModel(store: store))
	}
	.task {
		await store.listen()
	}
}
