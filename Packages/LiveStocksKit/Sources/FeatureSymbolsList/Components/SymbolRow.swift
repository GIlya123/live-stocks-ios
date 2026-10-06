//
//  SymbolRow.swift
//  FeatureSymbolsList
//
//  Created by GIlya123 on 06.10.2026.
//

import DesignSystem
import Domain
import SwiftUI

struct SymbolRow: View {
	let liveQuote: LiveQuote

	@Environment(\.locale) private var locale

	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(liveQuote.quote.symbol.ticker)
					.font(.headline)
				Text(liveQuote.quote.symbol.name)
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}
			Spacer()
			PriceChangeView(
				PriceChangeView.Model(
					liveQuote.quote,
					locale: locale
				)
			)
		}
	}
}
