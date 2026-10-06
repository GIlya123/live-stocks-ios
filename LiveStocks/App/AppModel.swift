//
//  AppModel.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation
import Observation
import SwiftUI

/// Owns the container of the current region and rebuilds it when the region changes
@Observable
final class AppModel {
	private(set) var container: AppContainer

	private let storage: SettingsStorage
	private let makeContainer: (Region) -> AppContainer
	/// Set while a switch waits for the old feed to stop, a second selection is ignored meanwhile
	@ObservationIgnored private var switchTask: Task<Void, Never>?
	/// Lifecycle changes run one after another, so a quick background and back can't overlap
	@ObservationIgnored private var lifecycleTask: Task<Void, Never>?
	/// Whether the feed was running when the app went to the background
	@ObservationIgnored private var resumesOnActive = false

	init(
		storage: SettingsStorage = UserDefaultsSettingsStorage(),
		locale: Locale = .current,
		makeContainer: @escaping (Region) -> AppContainer = { AppContainer.live(configuration: .make(for: $0)) }
	) {
		self.storage = storage
		self.makeContainer = makeContainer
		container = makeContainer(
			Region.resolve(
				saved: storage.savedRegion,
				locale: locale
			)
		)
	}

	var region: Region {
		container.region
	}

	// MARK: - Region

	/// Called from the UI, the switch outlives the picker and the screens it rebuilds
	func selectRegion(_ region: Region) {
		guard switchTask == nil else {
			return
		}

		switchTask = Task {
			await switchRegion(to: region)
			switchTask = nil
		}
	}

	/// Stops the old feed and keeps it running in the new region if it was running before
	func switchRegion(to region: Region) async {
		guard region != self.region else {
			return
		}

		let wasRunning = container.store.connectionState != .disconnected
		await container.store.stop()
		storage.savedRegion = region
		container = makeContainer(region)
		if wasRunning {
			await container.store.start()
		}
	}

	// MARK: - Lifecycle

	/// Called from the app on every scene phase change
	func handleScenePhase(_ phase: ScenePhase) {
		let previous = lifecycleTask
		lifecycleTask = Task {
			await previous?.value
			switch phase {
			case .background:
				await didEnterBackground()
			case .active:
				await didBecomeActive()
			default:
				// Inactive is a short pause like Control Center, the feed keeps running
				break
			}
		}
	}

	/// iOS suspends the app soon after this, closing the socket now avoids a long reconnect on return
	func didEnterBackground() async {
		resumesOnActive = container.store.connectionState != .disconnected
		if resumesOnActive {
			await container.store.stop()
		}
	}

	func didBecomeActive() async {
		guard resumesOnActive else {
			return
		}

		resumesOnActive = false
		await container.store.start()
	}
}
