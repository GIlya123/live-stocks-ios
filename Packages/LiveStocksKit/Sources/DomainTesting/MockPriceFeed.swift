//
//  MockPriceFeed.swift
//  DomainTesting
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation

/// Feed that tests drive by hand
public actor MockPriceFeed: PriceStreaming {
	public private(set) var startCount = 0
	public private(set) var stopCount = 0
	private var state = ConnectionState.disconnected
	private var continuations: [AsyncStream<PriceFeedUpdate>.Continuation] = []

	public init() {}

	public func updates() -> AsyncStream<PriceFeedUpdate> {
		let (stream, continuation) = AsyncStream.makeStream(of: PriceFeedUpdate.self)
		continuation.yield(.state(state))
		continuations.append(continuation)
		return stream
	}

	public func start() {
		startCount += 1
	}

	public func stop() {
		stopCount += 1
	}

	public func send(_ update: PriceFeedUpdate) {
		if case .state(let state) = update {
			self.state = state
		}
		for continuation in continuations {
			continuation.yield(update)
		}
	}

	/// Lets the code under test subscribe before updates are sent
	public func waitForSubscriber() async {
		while continuations.isEmpty {
			await Task.yield()
		}
	}
}

/// Gives the main actor turns until the condition holds, tests bound it with a time limit
@MainActor
public func waitUntil(_ condition: () -> Bool) async {
	while !condition() {
		await Task.yield()
	}
}
