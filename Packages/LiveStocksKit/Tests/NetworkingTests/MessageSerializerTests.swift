//
//  MessageSerializerTests.swift
//  NetworkingTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation
import Networking
import Testing

struct MessageSerializerTests {
	private struct Message: Codable, Equatable {
		let id: Int
		let text: String
	}

	private let serializer = MessageSerializer()

	@Test func roundTripsMessage() throws {
		// Given
		let message = Message(
			id: 1,
			text: "hello"
		)

		// When
		let decoded = try serializer.decode(Message.self, from: try serializer.encode(message))

		// Then
		#expect(decoded == message)
	}

	@Test(arguments: [
		"not json",
		#"{"id":1}"#,
	])
	func throwsOnInvalidText(text: String) {
		#expect(throws: DecodingError.self) {
			try serializer.decode(Message.self, from: text)
		}
	}
}
