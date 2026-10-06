//
//  SymbolsListViewModelTests.swift
//  FeatureSymbolsListTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import DomainTesting
import FeatureSymbolsList
import Foundation
import Testing

@MainActor
@Suite(.timeLimit(.minutes(1)))
struct SymbolsListViewModelTests {
	private let feed = MockPriceFeed()

	@Test func sortsByPriceHighestFirst() {
		// When
		let viewModel = SymbolsListViewModel(store: makeStore())

		// Then
		#expect(viewModel.rows.map(\.id) == ["MSFT", "AAPL", "NVDA"])
	}

	@Test func resortsRightAwayWhenOptionChanges() async {
		// Given
		let store = makeStore()
		let viewModel = SymbolsListViewModel(store: store)
		await listen(to: store)
		await feed.send(.tick(.fixture("NVDA", price: 110, sequence: 1)))
		await waitUntil { store.quotes.last?.quote.price == 110 }

		// When
		viewModel.sortOption = .priceChange

		// Then
		#expect(viewModel.rows.map(\.id) == ["NVDA", "AAPL", "MSFT"])
	}

	@Test func keepsOrderFreshWhilePricesMove() async {
		// Given
		let store = makeStore()
		let viewModel = SymbolsListViewModel(
			store: store,
			resortInterval: .milliseconds(10)
		)
		await listen(to: store)
		let sorting = Task {
			await viewModel.keepSorted()
		}
		defer { sorting.cancel() }

		// When
		await feed.send(.tick(.fixture("NVDA", price: 500, sequence: 1)))

		// Then
		await waitUntil { viewModel.rows.first?.id == "NVDA" }
	}

	@Test func startsFeedWhenStopped() async {
		// Given
		let viewModel = SymbolsListViewModel(store: makeStore())

		// When
		await viewModel.toggleFeed()

		// Then
		#expect(await feed.startCount == 1)
		#expect(await feed.stopCount == 0)
	}

	@Test(arguments: [
		ConnectionState.connecting,
		.connected,
		.reconnecting(attempt: 1),
	])
	func stopsFeedWhileRunning(state: ConnectionState) async {
		// Given
		let store = makeStore()
		let viewModel = SymbolsListViewModel(store: store)
		await listen(to: store)
		await feed.send(.state(state))
		await waitUntil { viewModel.isRunning }

		// When
		await viewModel.toggleFeed()

		// Then
		#expect(await feed.stopCount == 1)
		#expect(await feed.startCount == 0)
	}

	private func makeStore() -> QuoteStore {
		QuoteStore(
			quotes: [
				.fixture("AAPL", open: 150),
				.fixture("MSFT", open: 400),
				.fixture("NVDA", open: 100),
			],
			feed: feed
		)
	}

	/// The listening task lives until the test ends, the mock feed never finishes the stream
	private func listen(to store: QuoteStore) async {
		Task {
			await store.listen()
		}
		await feed.waitForSubscriber()
	}
}
