// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "LiveStocksKit",
	defaultLocalization: "en",
	platforms: [.iOS(.v17)],
	products: [
		.library(
			name: "Domain",
			targets: [
				"Domain"
			]
		),
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
				"Domain",
				"DomainTesting",
			]
		),
		.target(
			name: "DomainTesting",
			dependencies: [
				"Domain"
			]
		),
		.target(
			name: "Networking"
		),
		.testTarget(
			name: "NetworkingTests",
			dependencies: [
				"Networking"
			]
		),
		.testTarget(
			name: "NetworkingIntegrationTests",
			dependencies: [
				"Networking"
			]
		),
		.target(
			name: "PriceFeed",
			dependencies: [
				"Domain",
				"Networking",
			]
		),
		.testTarget(
			name: "PriceFeedTests",
			dependencies: [
				"PriceFeed",
				"Domain",
				"Networking",
			]
		),

		// UI
		.target(
			name: "DesignSystem"
		),
		.target(
			name: "QuotesUI",
			dependencies: [
				"Domain",
				"DesignSystem",
			]
		),
		.testTarget(
			name: "QuotesUITests",
			dependencies: [
				"QuotesUI",
				"Domain",
				"DesignSystem",
				"DomainTesting",
			]
		),
		.target(
			name: "FeatureSymbolsList",
			dependencies: [
				"Domain",
				"DesignSystem",
				"QuotesUI",
			]
		),
		.testTarget(
			name: "FeatureSymbolsListTests",
			dependencies: [
				"FeatureSymbolsList",
				"Domain",
				"DomainTesting",
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
