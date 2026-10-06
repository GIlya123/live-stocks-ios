//
//  AppModelTests.swift
//  LiveStocksTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation
import Testing

@testable import LiveStocks

@MainActor
struct AppModelTests {
	private let storage = InMemorySettingsStorage()
	private let feeds = Feeds()

	@Test func startsInSavedRegion() {
		// Given
		storage.savedRegion = .unitedArabEmirates

		// When
		let model = makeModel()

		// Then
		#expect(model.region == .unitedArabEmirates)
	}

	@Test func switchingStopsOldFeedAndRemembersRegion() async {
		// Given
		let model = makeModel()

		// When
		await model.switchRegion(to: .unitedArabEmirates)

		// Then
		#expect(model.region == .unitedArabEmirates)
		#expect(storage.savedRegion == .unitedArabEmirates)
		#expect(await feeds[.unitedStates].stopCount == 1)
		#expect(await feeds[.unitedArabEmirates].startCount == 0)
	}

	@Test func keepsFeedRunningAfterSwitchWhenItWasRunning() async {
		// Given
		let model = makeModel()
		let listening = Task {
			await model.container.store.listen()
		}
		defer { listening.cancel() }
		await model.container.store.start()
		while model.container.store.connectionState != .connected {
			try? await Task.sleep(for: .milliseconds(1))
		}

		// When
		await model.switchRegion(to: .unitedArabEmirates)

		// Then
		#expect(await feeds[.unitedArabEmirates].startCount == 1)
	}

	@Test func ignoresSecondSelectionWhileSwitching() async {
		// Given
		let model = makeModel()

		// When
		model.selectRegion(.unitedArabEmirates)
		model.selectRegion(.unitedStates)
		while storage.savedRegion == nil {
			try? await Task.sleep(for: .milliseconds(1))
		}

		// Then
		#expect(model.region == .unitedArabEmirates)
		#expect(storage.savedRegion == .unitedArabEmirates)
	}

	private func makeModel() -> AppModel {
		AppModel(
			storage: storage,
			locale: Locale(identifier: "en_US")
		) { region in
			AppContainer(
				configuration: .make(for: region),
				feed: feeds[region]
			)
		}
	}
}

private final class InMemorySettingsStorage: SettingsStorage {
	var savedRegion: Region?
}

/// One fake feed per region, so tests can check which one was started or stopped
@MainActor
private final class Feeds {
	private var feeds: [Region: CountingFeed] = [:]

	subscript(region: Region) -> CountingFeed {
		if let feed = feeds[region] {
			return feed
		}
		let feed = CountingFeed()
		feeds[region] = feed
		return feed
	}
}

/// Connects right away on start and counts start and stop calls
private actor CountingFeed: PriceStreaming {
	private(set) var startCount = 0
	private(set) var stopCount = 0
	private var continuations: [AsyncStream<PriceFeedUpdate>.Continuation] = []
	private var state = ConnectionState.disconnected

	func updates() -> AsyncStream<PriceFeedUpdate> {
		let (stream, continuation) = AsyncStream.makeStream(of: PriceFeedUpdate.self)
		continuation.yield(.state(state))
		continuations.append(continuation)
		return stream
	}

	func start() {
		startCount += 1
		publish(.connected)
	}

	func stop() {
		stopCount += 1
		publish(.disconnected)
	}

	private func publish(_ state: ConnectionState) {
		self.state = state
		for continuation in continuations {
			continuation.yield(.state(state))
		}
	}
}
