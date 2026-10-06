//
//  SymbolsListViewModel.swift
//  FeatureSymbolsList
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation
import Observation

@MainActor
@Observable
public final class SymbolsListViewModel {
	public var sortOption = QuoteSortOption.price {
		didSet {
			resort()
		}
	}
	public private(set) var rows: [LiveQuote] = []

	private let store: QuoteStore
	private let resortInterval: Duration

	/// Rows are resorted once per interval, not on every tick, so they don't jump around
	public init(
		store: QuoteStore,
		resortInterval: Duration = .seconds(1)
	) {
		self.store = store
		self.resortInterval = resortInterval
		resort()
	}

	public var connectionState: ConnectionState {
		store.connectionState
	}

	/// Connecting and reconnecting count as running, the button stops them too
	public var isRunning: Bool {
		connectionState != .disconnected
	}

	public func toggleFeed() async {
		if isRunning {
			await store.stop()
		} else {
			await store.start()
		}
	}

	/// Keeps the order fresh until the calling task is cancelled
	public func keepSorted() async {
		// Catches up right away when the screen comes back, e.g. from details
		resort()
		while true {
			do {
				try await Task.sleep(for: resortInterval)
			} catch {
				return
			}
			resort()
		}
	}

	private func resort() {
		let sorted = store.quotes
			.map(\.quote)
			.sorted(by: sortOption)
			.compactMap { store.liveQuote(for: $0.symbol) }
		if sorted.map(\.id) != rows.map(\.id) {
			rows = sorted
		}
	}
}
