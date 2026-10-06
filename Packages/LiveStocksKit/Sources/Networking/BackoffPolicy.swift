//
//  BackoffPolicy.swift
//  Networking
//
//  Created by GIlya123 on 06.10.2026.
//

import Foundation

/// Doubling backoff with jitter for reconnect attempts
public struct BackoffPolicy: Sendable {
	private enum Constants {
		/// Past this the delay is long capped, keeps the growth factor finite
		static let maxExponent = 16
	}

	public let initialDelay: Duration
	public let maxDelay: Duration

	public init(
		initialDelay: Duration = .seconds(1),
		maxDelay: Duration = .seconds(30)
	) {
		self.initialDelay = initialDelay
		self.maxDelay = maxDelay
	}

	/// Delay before the given attempt, attempts start from 1
	/// Jitter from 0 to 1 picks a point between half and full delay
	public func delay(
		forAttempt attempt: Int,
		jitter: Double
	) -> Duration {
		fullDelay(forAttempt: attempt) * (1 + jitter) / 2
	}

	public func delay(forAttempt attempt: Int) -> Duration {
		delay(
			forAttempt: attempt,
			jitter: .random(in: 0...1)
		)
	}

	private func fullDelay(forAttempt attempt: Int) -> Duration {
		let exponent = min(
			max(attempt - 1, 0),
			Constants.maxExponent
		)
		return min(
			initialDelay * pow(2, Double(exponent)),
			maxDelay
		)
	}
}
