//
//  LivePriceFeed.swift
//  PriceFeed
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation
import Networking

/// Generates prices, sends them to the echo server and publishes what comes back
public actor LivePriceFeed: PriceStreaming {
	private enum Constants {
		/// Echoes missed in a row before the connection counts as dead
		static let maxMissedEchoes = 3
	}

	private enum FeedError: Error {
		/// Server stopped echoing, the connection is treated as dead
		case echoTimedOut
	}

	private let url: URL
	private let transport: any WebSocketTransport
	private let interval: Duration
	private let backoff: BackoffPolicy
	private let serializer = MessageSerializer()
	private var generator: PriceGenerator

	private var state = ConnectionState.disconnected
	private var subscribers: [UUID: AsyncStream<PriceFeedUpdate>.Continuation] = [:]
	private var runTask: Task<Void, Never>?
	/// Bumped on every start and stop, so a stale run can't publish after it
	private var epoch = 0
	private var sequence = 0
	private var missedEchoes = 0

	public init(
		url: URL,
		openPrices: [String: Decimal],
		transport: any WebSocketTransport = URLSessionWebSocketTransport(),
		interval: Duration = .seconds(2),
		backoff: BackoffPolicy = BackoffPolicy()
	) {
		self.url = url
		self.transport = transport
		self.interval = interval
		self.backoff = backoff
		self.generator = PriceGenerator(openPrices: openPrices)
	}

	public func updates() -> AsyncStream<PriceFeedUpdate> {
		let (stream, continuation) = AsyncStream.makeStream(of: PriceFeedUpdate.self)
		let id = UUID()
		continuation.yield(.state(state))
		continuation.onTermination = { [weak self] _ in
			Task {
				await self?.removeSubscriber(id)
			}
		}
		subscribers[id] = continuation
		return stream
	}

	public func start() {
		guard runTask == nil else {
			return
		}

		epoch += 1
		let epoch = epoch
		runTask = Task {
			await run(epoch: epoch)
		}
	}

	public func stop() {
		guard let runTask else {
			return
		}

		runTask.cancel()
		self.runTask = nil
		epoch += 1
		publish(.disconnected)
	}

	// MARK: - Connection

	private func run(epoch: Int) async {
		var attempt = 0
		publish(.connecting)

		while isCurrent(epoch) {
			do {
				let connection = try await transport.connect(to: url)
				guard isCurrent(epoch) else {
					connection.close()
					return
				}

				attempt = 0
				publish(.connected)
				try await stream(over: connection, epoch: epoch)
			} catch {
				// Any failure ends in a reconnect below
			}

			guard isCurrent(epoch) else {
				return
			}

			attempt += 1
			publish(.reconnecting(attempt: attempt))
			try? await Task.sleep(for: backoff.delay(forAttempt: attempt))
		}
	}

	/// Returns or throws once the connection is no longer usable
	private func stream(
		over connection: any WebSocketConnection,
		epoch: Int
	) async throws {
		defer {
			connection.close()
		}

		missedEchoes = 0
		try await withThrowingTaskGroup(of: Void.self) { group in
			group.addTask {
				try await self.receive(
					from: connection,
					epoch: epoch
				)
			}
			group.addTask {
				try await self.sendPrices(to: connection)
			}
			try await group.next()
			group.cancelAll()
		}
	}

	private func receive(
		from connection: any WebSocketConnection,
		epoch: Int
	) async throws {
		for try await text in connection.messages {
			guard isCurrent(epoch) else {
				return
			}

			missedEchoes = 0
			if let tick = (try? serializer.decode(PriceMessage.self, from: text))?.tick {
				broadcast(.tick(tick))
			}
		}
	}

	private func sendPrices(to connection: any WebSocketConnection) async throws {
		while true {
			guard missedEchoes < Constants.maxMissedEchoes else {
				throw FeedError.echoTimedOut
			}

			for text in try nextMessages() {
				try await connection.send(text)
			}
			missedEchoes += 1
			try await Task.sleep(for: interval)
		}
	}

	private func nextMessages() throws -> [String] {
		var messages: [String] = []
		for ticker in generator.tickers {
			sequence += 1
			let tick = PriceTick(
				ticker: ticker,
				price: generator.nextPrice(for: ticker),
				sequence: sequence,
				timestamp: .now
			)
			messages.append(try serializer.encode(PriceMessage(tick)))
		}
		return messages
	}

	// MARK: - Subscribers

	private func isCurrent(_ epoch: Int) -> Bool {
		epoch == self.epoch && !Task.isCancelled
	}

	private func publish(_ state: ConnectionState) {
		self.state = state
		broadcast(.state(state))
	}

	private func broadcast(_ update: PriceFeedUpdate) {
		for continuation in subscribers.values {
			continuation.yield(update)
		}
	}

	private func removeSubscriber(_ id: UUID) {
		subscribers[id] = nil
	}
}
