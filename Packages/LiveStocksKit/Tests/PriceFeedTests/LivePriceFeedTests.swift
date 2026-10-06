//
//  LivePriceFeedTests.swift
//  PriceFeedTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation
import Networking
import Testing

@testable import PriceFeed

@Suite(.timeLimit(.minutes(1)))
struct LivePriceFeedTests {
	@Test func publishesEchoedPricesOnceConnected() async throws {
		// Given
		let feed = try makeFeed(transport: FakeTransport())
		var updates = await feed.updates().makeAsyncIterator()

		// When
		await feed.start()

		// Then
		#expect(await updates.next() == .state(.disconnected))
		#expect(await updates.next() == .state(.connecting))
		#expect(await updates.next() == .state(.connected))
		let first = try #require(await updates.nextTick())
		let second = try #require(await updates.nextTick())
		#expect(first.ticker == "AAPL")
		#expect(first.sequence == 1)
		#expect(second.ticker == "MSFT")
		#expect(second.sequence == 2)
	}

	@Test func reconnectsAfterConnectionDrops() async throws {
		// Given
		let transport = FakeTransport()
		let feed = try makeFeed(transport: transport)
		var updates = await feed.updates().makeAsyncIterator()
		var connections = transport.connections.makeAsyncIterator()
		await feed.start()
		#expect(await updates.nextState(after: .disconnected, .connecting) == .connected)
		let connection = try #require(await connections.next())

		// When
		connection.drop()

		// Then
		#expect(await updates.nextState() == .reconnecting(attempt: 1))
		#expect(connection.isClosed)
		#expect(await updates.nextState() == .connected)
	}

	@Test func reconnectsWhenEchoStops() async throws {
		// Given
		let feed = try makeFeed(transport: FakeTransport(echoes: false))
		var updates = await feed.updates().makeAsyncIterator()

		// When
		await feed.start()

		// Then
		#expect(await updates.nextState(after: .disconnected, .connecting) == .connected)
		#expect(await updates.nextState() == .reconnecting(attempt: 1))
	}

	@Test func retriesWhenConnectFails() async throws {
		// Given
		let feed = try makeFeed(transport: FakeTransport(failures: 1))
		var updates = await feed.updates().makeAsyncIterator()

		// When
		await feed.start()

		// Then
		#expect(await updates.nextState(after: .disconnected, .connecting) == .reconnecting(attempt: 1))
		#expect(await updates.nextState() == .connected)
	}

	@Test func stopClosesConnectionAndDisconnects() async throws {
		// Given
		let transport = FakeTransport()
		let feed = try makeFeed(transport: transport)
		var updates = await feed.updates().makeAsyncIterator()
		var connections = transport.connections.makeAsyncIterator()
		await feed.start()
		#expect(await updates.nextState(after: .disconnected, .connecting) == .connected)
		let connection = try #require(await connections.next())

		// When
		await feed.stop()

		// Then
		#expect(await updates.nextState() == .disconnected)
		await connection.waitUntilClosed()
	}

	private func makeFeed(transport: FakeTransport) throws -> LivePriceFeed {
		LivePriceFeed(
			url: try #require(URL(string: "wss://echo.test")),
			openPrices: [
				"AAPL": 100,
				"MSFT": 200,
			],
			transport: transport,
			interval: .milliseconds(10),
			backoff: BackoffPolicy(
				initialDelay: .milliseconds(1),
				maxDelay: .milliseconds(1)
			)
		)
	}
}

extension AsyncStream<PriceFeedUpdate>.Iterator {
	/// Skips ticks and the given states
	fileprivate mutating func nextState(after skipped: ConnectionState...) async -> ConnectionState? {
		while let update = await next() {
			if case .state(let state) = update, !skipped.contains(state) {
				return state
			}
		}
		return nil
	}

	fileprivate mutating func nextTick() async -> PriceTick? {
		while let update = await next() {
			if case .tick(let tick) = update {
				return tick
			}
		}
		return nil
	}
}
