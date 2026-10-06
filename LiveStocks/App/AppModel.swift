//
//  AppModel.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation
import Observation

/// Owns the container of the current region and rebuilds it when the region changes
@Observable
final class AppModel {
	private(set) var container: AppContainer

	private let storage: SettingsStorage
	private let makeContainer: (Region) -> AppContainer
	/// Set while a switch waits for the old feed to stop, a second selection is ignored meanwhile
	@ObservationIgnored private var switchTask: Task<Void, Never>?

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
}
