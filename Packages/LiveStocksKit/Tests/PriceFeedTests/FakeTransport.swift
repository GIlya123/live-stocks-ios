//
//  FakeTransport.swift
//  PriceFeedTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation
import Networking

/// Hands out fake connections, fails the first connects if asked to
final class FakeTransport: WebSocketTransport, @unchecked Sendable {
	let connections: AsyncStream<FakeConnection>
	private let connectionsContinuation: AsyncStream<FakeConnection>.Continuation
	private let lock = NSLock()
	private var failuresLeft: Int
	private let echoes: Bool

	init(
		failures: Int = 0,
		echoes: Bool = true
	) {
		(connections, connectionsContinuation) = AsyncStream.makeStream()
		failuresLeft = failures
		self.echoes = echoes
	}

	func connect(to url: URL) async throws -> any WebSocketConnection {
		let fails = lock.withLock {
			defer { failuresLeft -= 1 }
			return failuresLeft > 0
		}
		if fails {
			throw URLError(.cannotConnectToHost)
		}

		let connection = FakeConnection(echoes: echoes)
		connectionsContinuation.yield(connection)
		return connection
	}
}

/// Echoes sent messages back like the echo server
final class FakeConnection: WebSocketConnection, @unchecked Sendable {
	let messages: AsyncThrowingStream<String, any Error>
	private let messagesContinuation: AsyncThrowingStream<String, any Error>.Continuation
	private let lock = NSLock()
	private let echoes: Bool
	private var closed = false

	init(echoes: Bool) {
		(messages, messagesContinuation) = AsyncThrowingStream.makeStream()
		self.echoes = echoes
	}

	var isClosed: Bool {
		lock.withLock { closed }
	}

	func send(_ text: String) async throws {
		if echoes {
			messagesContinuation.yield(text)
		}
	}

	func ping() async throws {}

	func close() {
		lock.withLock { closed = true }
		messagesContinuation.finish()
	}

	func drop() {
		messagesContinuation.finish(throwing: URLError(.networkConnectionLost))
	}

	func waitUntilClosed() async {
		while !isClosed {
			await Task.yield()
		}
	}
}
