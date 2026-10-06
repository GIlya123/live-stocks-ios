// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "LiveStocksKit",
	defaultLocalization: "en",
	platforms: [.iOS(.v17)],
	products: [
		.library(
			name: "PriceFeed",
			targets: [
				"PriceFeed"
			]
		),
		.library(
			name: "FeatureSymbolsList",
			targets: [
				"FeatureSymbolsList"
			]
		),
		.library(
			name: "FeatureSymbolDetails",
			targets: [
				"FeatureSymbolDetails"
			]
		),
	],
	targets: [
		// Core
		.target(
			name: "Domain"
		),
		.testTarget(
			name: "DomainTests",
			dependencies: [
				"Domain"
			]
		),
		.target(
			name: "Networking"
		),
		.target(
			name: "PriceFeed",
			dependencies: [
				"Domain",
				"Networking",
			]
		),

		// UI
		.target(
			name: "DesignSystem",
			dependencies: [
				"Domain"
			]
		),
		.target(
			name: "FeatureSymbolsList",
			dependencies: [
				"Domain",
				"DesignSystem",
			]
		),
		.target(
			name: "FeatureSymbolDetails",
			dependencies: [
				"Domain",
				"DesignSystem",
			]
		),
	]
)
