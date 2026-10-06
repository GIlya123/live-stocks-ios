//
//  ConnectionStatusView.swift
//  FeatureSymbolsList
//
//  Created by GIlya123 on 06.10.2026.
//

import DesignSystem
import Domain
import SwiftUI

struct ConnectionStatusView: View {
	let state: ConnectionState

	var body: some View {
		Label {
			Text(title, bundle: .module)
		} icon: {
			Circle()
				.fill(color)
				.frame(
					width: IconSize.size8,
					height: IconSize.size8
				)
		}
		.font(.footnote)
		.labelStyle(.titleAndIcon)
	}

	private var title: LocalizedStringKey {
		switch state {
		case .connected:
			"Connected"
		case .connecting, .reconnecting:
			"Connecting"
		case .disconnected:
			"Disconnected"
		}
	}

	private var color: Color {
		switch state {
		case .connected:
			.green
		case .connecting, .reconnecting:
			.orange
		case .disconnected:
			.gray
		}
	}
}
