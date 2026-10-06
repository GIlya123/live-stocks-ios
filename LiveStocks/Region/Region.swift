//
//  Region.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

/// Markets the app supports, raw values are ISO 3166 region codes
enum Region: String, CaseIterable, Identifiable {
	case unitedStates = "US"
	case unitedArabEmirates = "AE"

	var id: String {
		rawValue
	}

	/// The region the user picked, then the device region, then the US
	static func resolve(
		saved: Region?,
		locale: Locale
	) -> Region {
		if let saved {
			return saved
		}
		if let code = locale.region?.identifier, let region = Region(rawValue: code) {
			return region
		}
		return .unitedStates
	}

	var flag: String {
		switch self {
		case .unitedStates:
			"🇺🇸"
		case .unitedArabEmirates:
			"🇦🇪"
		}
	}

	/// Comes from the system
	func name(in locale: Locale) -> String {
		locale.localizedString(forRegionCode: rawValue) ?? rawValue
	}
}
