//
//  RootView.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import Domain
import FeatureSymbolsList
import SwiftUI

/// Screens of one region, the app recreates it when the region changes
struct RootView: View {
	let model: AppModel

	@State private var listViewModel: SymbolsListViewModel
	@State private var isPickingRegion = false

	init(model: AppModel) {
		self.model = model
		_listViewModel = State(initialValue: model.container.makeSymbolsListViewModel())
	}

	var body: some View {
		NavigationStack {
			SymbolsListView(viewModel: listViewModel)
				.navigationDestination(for: StockSymbol.self) { symbol in
					model.container.makeSymbolDetailsView(for: symbol)
				}
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						Button {
							isPickingRegion = true
						} label: {
							Text(model.region.flag)
						}
					}
				}
		}
		.task {
			await model.container.store.listen()
		}
		.sheet(isPresented: $isPickingRegion) {
			RegionPickerView(selected: model.region) { region in
				isPickingRegion = false
				model.selectRegion(region)
			}
		}
	}
}
