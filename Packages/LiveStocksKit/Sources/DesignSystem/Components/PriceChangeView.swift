//
//  PriceChangeView.swift
//  DesignSystem
//
//  Created by GIlya123 on 06.10.2026.
//

import SwiftUI

/// Price with its change and a trend arrow, shared by the list and the details screen
public struct PriceChangeView: View {
	public struct Model: Equatable, Sendable {
		/// Picks the arrow and color, flat has no arrow and is gray
		public enum Trend: Sendable {
			case up
			case down
			case flat
		}

		public let price: String
		public let change: String
		public let trend: Trend

		public init(
			price: String,
			change: String,
			trend: Trend
		) {
			self.price = price
			self.change = change
			self.trend = trend
		}
	}

	private let model: Model

	public init(_ model: Model) {
		self.model = model
	}

	public var body: some View {
		VStack(
			alignment: .trailing,
			spacing: Spacing.space2
		) {
			Text(model.price)
				.font(.body.monospacedDigit())
				.contentTransition(.numericText())
			HStack(spacing: Spacing.space2) {
				if let arrowName {
					Image(systemName: arrowName)
				}
				Text(model.change)
					.contentTransition(.numericText())
			}
			.font(.caption.monospacedDigit())
			.foregroundStyle(color)
		}
		.animation(
			.default,
			value: model
		)
	}

	/// No arrow for flat, a dash before 0.00% reads as a minus
	private var arrowName: String? {
		switch model.trend {
		case .up:
			"arrow.up.right"
		case .down:
			"arrow.down.right"
		case .flat:
			nil
		}
	}

	private var color: Color {
		switch model.trend {
		case .up:
			.green
		case .down:
			.red
		case .flat:
			.secondary
		}
	}
}

#Preview {
	VStack(spacing: Spacing.space16) {
		PriceChangeView(
			PriceChangeView.Model(
				price: "$189.27",
				change: "+1.25%",
				trend: .up
			)
		)
		PriceChangeView(
			PriceChangeView.Model(
				price: "$412.10",
				change: "-0.40%",
				trend: .down
			)
		)
		PriceChangeView(
			PriceChangeView.Model(
				price: "$98.00",
				change: "0.00%",
				trend: .flat
			)
		)
	}
}
