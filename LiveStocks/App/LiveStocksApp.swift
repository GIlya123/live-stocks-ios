//
//  LiveStocksApp.swift
//  LiveStocks
//
//  Created by GIlya123 on 05.10.2026.
//

import Domain
import FeatureSymbolsList
import SwiftUI

@main
struct LiveStocksApp: App {
	private let container: AppContainer
	@State private var listViewModel: SymbolsListViewModel

	init() {
		let container = AppContainer()
		self.container = container
		_listViewModel = State(initialValue: container.makeSymbolsListViewModel())
	}

	var body: some Scene {
		WindowGroup {
			NavigationStack {
				SymbolsListView(viewModel: listViewModel)
					.navigationDestination(for: StockSymbol.self) { symbol in
						container.makeSymbolDetailsView(for: symbol)
					}
			}
			.task {
				await container.store.listen()
			}
		}
	}
}
