//
//  AppConfiguration.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import Foundation

/// Settings that can differ between environments and regions
struct AppConfiguration {
	let region: Region
	let priceFeedURL: URL
	let quotes: [StockQuote]
}

extension AppConfiguration {
	static func make(for region: Region) -> AppConfiguration {
		AppConfiguration(
			region: region,
			// Same echo server everywhere for now, a real app would point each region at its own backend
			priceFeedURL: url("wss://ws.postman-echo.com/raw"),
			quotes: SymbolCatalog.quotes(for: region)
		)
	}

	private static func url(_ string: String) -> URL {
		guard let url = URL(string: string) else {
			preconditionFailure("Invalid URL in configuration: \(string)")
		}

		return url
	}
}
