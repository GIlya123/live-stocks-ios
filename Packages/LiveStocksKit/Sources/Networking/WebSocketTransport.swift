//
//  WebSocketTransport.swift
//  Networking
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

public protocol WebSocketTransport: Sendable {
	/// Returns once the connection is open and answered a ping
	func connect(to url: URL) async throws -> any WebSocketConnection
}

public protocol WebSocketConnection: Sendable {
	/// Incoming text messages. Finishes with an error when the connection drops
	var messages: AsyncThrowingStream<String, any Error> { get }

	func send(_ text: String) async throws
	func ping() async throws
	func close()
}
