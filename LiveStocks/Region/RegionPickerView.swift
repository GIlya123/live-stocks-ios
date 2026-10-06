//
//  RegionPickerView.swift
//  LiveStocks
//
//  Created by GIlya123 on 06.10.2026.
//

import SwiftUI

struct RegionPickerView: View {
	let selected: Region
	let onSelect: (Region) -> Void

	@Environment(\.locale) private var locale
	@Environment(\.openURL) private var openURL

	var body: some View {
		NavigationStack {
			List {
				Section {
					ForEach(Region.allCases) { region in
						regionRow(region)
					}
				}
				Section {
					languageRow
				} footer: {
					Text("Language follows the iOS settings of the app")
				}
			}
			.tint(.primary)
			.navigationTitle("Region")
			.navigationBarTitleDisplayMode(.inline)
		}
		.presentationDetents([.medium])
	}

	private func regionRow(_ region: Region) -> some View {
		Button {
			onSelect(region)
		} label: {
			HStack {
				Text(region.flag)
				Text(region.name(in: locale))
				Spacer()
				if region == selected {
					Image(systemName: "checkmark")
				}
			}
		}
	}

	/// Opens the app page in iOS settings, where the system lets the user pick the app language
	private var languageRow: some View {
		Button {
			if let url = URL(string: UIApplication.openSettingsURLString) {
				openURL(url)
			}
		} label: {
			HStack {
				Text("Language")
				Spacer()
				Text(languageName)
					.foregroundStyle(.secondary)
				Image(systemName: "arrow.up.forward.app")
					.foregroundStyle(.secondary)
			}
		}
	}

	private var languageName: String {
		let code = locale.language.languageCode?.identifier ?? ""
		return locale.localizedString(forLanguageCode: code) ?? code
	}
}

#Preview {
	RegionPickerView(selected: .unitedStates) { _ in }
}
