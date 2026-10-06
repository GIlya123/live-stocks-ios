//
//  Currency.swift
//  Domain
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

/// Currencies symbols trade in, raw values are ISO 4217 codes
public enum Currency: String, Sendable {
	case usd = "USD"
	case aed = "AED"
}
