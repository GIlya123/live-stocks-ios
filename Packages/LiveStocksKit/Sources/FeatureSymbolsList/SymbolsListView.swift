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
			NavigationLink(value: liveQuote.quote.symbol) {
				SymbolRow(liveQuote: liveQuote)
			}
		}
		.listStyle(.plain)
		.safeAreaInset(edge: .top) {
			header
		}
		.animation(
			.default,
			value: viewModel.rows.map(\.id)
		)
		.navigationTitle(Text("Stocks", bundle: .module))
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					Task {
						await viewModel.toggleFeed()
					}
				} label: {
					viewModel.isRunning ? Text("Stop", bundle: .module) : Text("Start", bundle: .module)
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
			Picker(selection: $viewModel.sortOption) {
				Text("Price", bundle: .module)
					.tag(QuoteSortOption.price)
				Text("Change", bundle: .module)
					.tag(QuoteSortOption.priceChange)
			} label: {
				Text("Sort", bundle: .module)
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
					name: "Apple",
					summary: "Consumer electronics",
					currency: .usd
				),
				openPrice: 189
			),
			StockQuote(
				symbol: StockSymbol(
					ticker: "NVDA",
					name: "NVIDIA",
					summary: "Graphics and AI chips",
					currency: .usd
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
