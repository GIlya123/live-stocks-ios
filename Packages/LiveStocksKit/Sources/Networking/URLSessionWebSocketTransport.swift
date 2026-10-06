//
//  URLSessionWebSocketTransport.swift
//  Networking
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

public struct URLSessionWebSocketTransport: WebSocketTransport {
	private let session: URLSession

	public init(session: URLSession = .shared) {
		self.session = session
	}

	public func connect(to url: URL) async throws -> any WebSocketConnection {
		let task = session.webSocketTask(with: url)
		task.resume()

		// resume() doesn't tell whether the handshake succeeded, a ping does
		let connection = URLSessionWebSocketConnection(task: task)
		do {
			try await connection.ping()
		} catch {
			connection.close()
			throw error
		}
		return connection
	}
}

final class URLSessionWebSocketConnection: WebSocketConnection {
	let messages: AsyncThrowingStream<String, any Error>
	private let task: URLSessionWebSocketTask

	init(task: URLSessionWebSocketTask) {
		self.task = task
		messages = AsyncThrowingStream { continuation in
			let receiving = Task {
				do {
					while true {
						switch try await task.receive() {
						case .string(let text):
							continuation.yield(text)
						case .data(let data):
							continuation.yield(String(decoding: data, as: UTF8.self))
						@unknown default:
							break
						}
					}
				} catch {
					continuation.finish(throwing: error)
				}
			}
			continuation.onTermination = { _ in
				receiving.cancel()
			}
		}
	}

	func send(_ text: String) async throws {
		try await task.send(.string(text))
	}

	func ping() async throws {
		try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
			task.sendPing { error in
				if let error {
					continuation.resume(throwing: error)
				} else {
					continuation.resume()
				}
			}
		}
	}

	func close() {
		task.cancel(
			with: .normalClosure,
			reason: nil
		)
	}
}
