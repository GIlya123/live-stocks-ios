//
//  QuoteStoreTests.swift
//  DomainTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import DomainTesting
import Foundation
import Testing

@MainActor
@Suite(.timeLimit(.minutes(1)))
struct QuoteStoreTests {
	private let feed = MockPriceFeed()

	@Test func appliesTicksToMatchingQuote() async throws {
		// Given
		let store = makeStore()
		let listening = Task {
			await store.listen()
		}
		defer { listening.cancel() }
		await feed.waitForSubscriber()
		let apple = try #require(store.quotes.first)

		// When
		await feed.send(.tick(.fixture("AAPL", price: 110, sequence: 1)))

		// Then
		await waitUntil { apple.quote.price == 110 }
		#expect(store.quotes.last?.quote.price == 200)
	}

	@Test func followsConnectionState() async {
		// Given
		let store = makeStore()
		let listening = Task {
			await store.listen()
		}
		defer { listening.cancel() }
		await feed.waitForSubscriber()

		// When
		await feed.send(.state(.connected))

		// Then
		await waitUntil { store.connectionState == .connected }
	}

	@Test func ignoresTicksForUnknownSymbols() async {
		// Given
		let store = makeStore()
		let listening = Task {
			await store.listen()
		}
		defer { listening.cancel() }
		await feed.waitForSubscriber()

		// When
		await feed.send(.tick(.fixture("TSLA", price: 1, sequence: 1)))
		await feed.send(.state(.connected))

		// Then
		await waitUntil { store.connectionState == .connected }
		#expect(store.quotes.map(\.quote.price) == [100, 200])
	}

	@Test func passesStartAndStopToFeed() async {
		// Given
		let store = makeStore()

		// When
		await store.start()
		await store.stop()

		// Then
		#expect(await feed.startCount == 1)
		#expect(await feed.stopCount == 1)
	}

	private func makeStore() -> QuoteStore {
		QuoteStore(
			quotes: [
				.fixture("AAPL", open: 100),
				.fixture("MSFT", open: 200),
			],
			feed: feed
		)
	}
}
