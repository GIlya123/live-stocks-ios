//
//  PriceFeedUpdate.swift
//  Domain
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

/// State changes and ticks share one stream so they arrive in order
public enum PriceFeedUpdate: Equatable, Sendable {
	case state(ConnectionState)
	case tick(PriceTick)
}
