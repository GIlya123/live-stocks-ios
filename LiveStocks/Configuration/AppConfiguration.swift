//
//  AppConfiguration.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

/// Settings that can differ between environments and regions
struct AppConfiguration {
	let priceFeedURL: URL
}

extension AppConfiguration {
	static let current = AppConfiguration(
		priceFeedURL: url("wss://ws.postman-echo.com/raw")
	)

	private static func url(_ string: String) -> URL {
		guard let url = URL(string: string) else {
			preconditionFailure("Invalid URL in configuration: \(string)")
		}

		return url
	}
}
