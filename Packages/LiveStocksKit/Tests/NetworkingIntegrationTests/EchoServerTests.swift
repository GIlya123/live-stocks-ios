//
//  EchoServerTests.swift
//  NetworkingIntegrationTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation
import Networking
import Testing

/// Uses the real echo server, needs network
struct EchoServerTests {
	@Test(.timeLimit(.minutes(1)))
	func echoesTextMessageBack() async throws {
		// Given
		let url = try #require(URL(string: "wss://ws.postman-echo.com/raw"))
		let connection = try await URLSessionWebSocketTransport().connect(to: url)
		defer { connection.close() }
		let message = UUID().uuidString

		// When
		try await connection.send(message)
		var messages = connection.messages.makeAsyncIterator()
		let echo = try await messages.next()

		// Then
		#expect(echo == message)
	}
}
