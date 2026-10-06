//
//  LiveQuote.swift
//  Domain
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation
import Observation

/// One quote that views observe, a tick redraws only the views that read it
@MainActor
@Observable
public final class LiveQuote: Identifiable {
	public let id: String
	public private(set) var quote: StockQuote

	init(_ quote: StockQuote) {
		self.id = quote.id
		self.quote = quote
	}

	func apply(_ tick: PriceTick) {
		var updated = quote
		// Assigns only when the tick is applied, so stale ticks don't redraw anything
		if updated.apply(tick) {
			quote = updated
		}
	}
}
