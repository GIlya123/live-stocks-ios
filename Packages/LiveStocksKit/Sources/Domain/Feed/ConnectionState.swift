//
//  ConnectionState.swift
//  Domain
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

public enum ConnectionState: Equatable, Sendable {
	case disconnected
	case connecting
	case connected
	/// Waiting before the given reconnect `attempt`
	case reconnecting(attempt: Int)
}
