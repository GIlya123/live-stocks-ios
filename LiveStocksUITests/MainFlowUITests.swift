//
//  MainFlowUITests.swift
//  LiveStocksUITests
//
//  Created by GIlya123 on 06.10.2026.
//

import XCTest

/// Walks the main flow without relying on the echo server, so prices and "Connected" aren't checked
final class MainFlowUITests: XCTestCase {
	private enum Constants {
		static let timeout: TimeInterval = 5
		/// Most expensive US symbol, it stays the first row when sorted by price
		static let topSymbol = "COST"
		static let topSymbolSummary = "Runs membership warehouse stores selling goods in bulk."
	}

	override func setUp() {
		continueAfterFailure = false
	}

	@MainActor
	func testBrowsesSymbolsAndControlsFeed() {
		// Given
		let app = launchApp()
		XCTAssertTrue(app.navigationBars["Stocks"].waitForExistence(timeout: Constants.timeout))
		XCTAssertTrue(app.staticTexts["Disconnected"].exists)

		// When the feed starts
		app.buttons["Start"].tap()

		// Then
		XCTAssertTrue(app.buttons["Stop"].waitForExistence(timeout: Constants.timeout))

		// When a row is opened
		app.staticTexts[Constants.topSymbol].tap()

		// Then
		XCTAssertTrue(app.navigationBars[Constants.topSymbol].waitForExistence(timeout: Constants.timeout))
		XCTAssertTrue(app.staticTexts[Constants.topSymbolSummary].exists)

		// When going back and sorting by change
		app.navigationBars.buttons.element(boundBy: 0).tap()
		XCTAssertTrue(app.navigationBars["Stocks"].waitForExistence(timeout: Constants.timeout))
		app.buttons["Change"].tap()

		// Then
		XCTAssertTrue(app.buttons["Change"].isSelected)

		// When the feed stops
		app.buttons["Stop"].tap()

		// Then
		XCTAssertTrue(app.buttons["Start"].waitForExistence(timeout: Constants.timeout))
		XCTAssertTrue(app.staticTexts["Disconnected"].exists)
	}

	/// Fixed language and region, so labels and the catalog are the same on every machine
	@MainActor
	private func launchApp() -> XCUIApplication {
		let app = XCUIApplication()
		app.launchArguments = [
			"-AppleLanguages", "(en)",
			"-AppleLocale", "en_US",
			"-region", "US",
		]
		app.launch()
		return app
	}
}
