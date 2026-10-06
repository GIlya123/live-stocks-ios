//
//  PriceStreaming.swift
//  Domain
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

/// Source of live prices, the app owns one and screens subscribe to it
public protocol PriceStreaming: Sendable {
	/// Every call returns a new stream that starts with the current state
	func updates() async -> AsyncStream<PriceFeedUpdate>
	func start() async
	func stop() async
}
