//
//  SettingsStorage.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

/// User choices that outlive the app session
protocol SettingsStorage: AnyObject {
	var savedRegion: Region? { get set }
}

final class UserDefaultsSettingsStorage: SettingsStorage {
	private enum Keys {
		static let region = "region"
	}

	private let defaults: UserDefaults

	init(defaults: UserDefaults = .standard) {
		self.defaults = defaults
	}

	var savedRegion: Region? {
		get {
			defaults.string(forKey: Keys.region).flatMap(Region.init)
		}
		set {
			defaults.set(
				newValue?.rawValue,
				forKey: Keys.region
			)
		}
	}
}
