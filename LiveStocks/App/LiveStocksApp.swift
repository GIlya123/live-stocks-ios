//
//  LiveStocksApp.swift
//  LiveStocks
//
//  Created by GIlya123 on 05.10.2026.
//

import SwiftUI

@main
struct LiveStocksApp: App {
	@State private var model = AppModel()
	@Environment(\.scenePhase) private var scenePhase

	var body: some Scene {
		WindowGroup {
			RootView(model: model)
				// A new region gets fresh screens, a fresh list and a new feed subscription
				.id(model.region)
				.onChange(of: scenePhase) { _, phase in
					model.handleScenePhase(phase)
				}
		}
	}
}
