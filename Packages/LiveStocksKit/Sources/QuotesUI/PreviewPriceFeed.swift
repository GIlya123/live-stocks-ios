//
//  PreviewPriceFeed.swift
//  QuotesUI
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation

/// Feed for SwiftUI previews that stays connected and never ticks
public struct PreviewPriceFeed: PriceStreaming {
	public init() {}

	public func updates() async -> AsyncStream<PriceFeedUpdate> {
		AsyncStream { continuation in
			continuation.yield(.state(.connected))
		}
	}

	public func start() async {}

	public func stop() async {}
}
