//
//  BackoffPolicyTests.swift
//  NetworkingTests
//
//  Created by GIlya123 on 06.10.2026.
//

import Networking
import Testing

struct BackoffPolicyTests {
	private let policy = BackoffPolicy(
		initialDelay: .seconds(1),
		maxDelay: .seconds(30)
	)

	@Test(arguments: [
		(1, Duration.milliseconds(500)),
		(2, Duration.seconds(1)),
		(3, Duration.seconds(2)),
		(4, Duration.seconds(4)),
	])
	func doublesDelayWithEveryAttempt(attempt: Int, expected: Duration) {
		// When
		let delay = policy.delay(forAttempt: attempt, jitter: 0)

		// Then
		#expect(delay == expected)
	}

	@Test func neverExceedsMaxDelay() {
		// When
		let delay = policy.delay(forAttempt: .max, jitter: 1)

		// Then
		#expect(delay == .seconds(30))
	}

	@Test func jitterKeepsDelayBetweenHalfAndFull() {
		// When
		let shortest = policy.delay(forAttempt: 3, jitter: 0)
		let longest = policy.delay(forAttempt: 3, jitter: 1)

		// Then
		#expect(shortest == .seconds(2))
		#expect(longest == .seconds(4))
	}

	@Test func treatsAttemptBelowOneAsFirst() {
		// When
		let delay = policy.delay(forAttempt: 0, jitter: 0)

		// Then
		#expect(delay == .milliseconds(500))
	}
}
