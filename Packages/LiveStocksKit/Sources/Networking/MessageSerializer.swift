//
//  MessageSerializer.swift
//  Networking
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

/// Turns Codable messages into WebSocket text frames and back
public struct MessageSerializer: Sendable {
	private let encoder: JSONEncoder
	private let decoder: JSONDecoder

	public init(
		encoder: JSONEncoder = JSONEncoder(),
		decoder: JSONDecoder = JSONDecoder()
	) {
		self.encoder = encoder
		self.decoder = decoder
	}

	public func encode(_ message: some Encodable) throws -> String {
		let data = try encoder.encode(message)
		return String(decoding: data, as: UTF8.self)
	}

	public func decode<Message: Decodable>(
		_ type: Message.Type,
		from text: String
	) throws -> Message {
		try decoder.decode(type, from: Data(text.utf8))
	}
}
