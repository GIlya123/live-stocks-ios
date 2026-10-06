//
//  RegionTests.swift
//  LiveStocksTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation
import Testing

@testable import LiveStocks

@MainActor
struct RegionTests {
	@Test func savedRegionWinsOverDeviceRegion() {
		// When
		let region = Region.resolve(
			saved: .unitedArabEmirates,
			locale: Locale(identifier: "en_US")
		)

		// Then
		#expect(region == .unitedArabEmirates)
	}

	@Test func usesDeviceRegionWhenNothingIsSaved() {
		// When
		let region = Region.resolve(
			saved: nil,
			locale: Locale(identifier: "ar_AE")
		)

		// Then
		#expect(region == .unitedArabEmirates)
	}

	@Test func fallsBackToUnitedStatesForUnsupportedDeviceRegion() {
		// When
		let region = Region.resolve(
			saved: nil,
			locale: Locale(identifier: "ru_RU")
		)

		// Then
		#expect(region == .unitedStates)
	}
}
