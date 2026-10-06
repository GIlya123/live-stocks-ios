# Testing

Tests use Swift Testing. Each module has its own test target, all of them are in the `Unit` test plan with Thread Sanitizer on. CI runs it on every PR.

Unit tests focus on the logic that is easy to get wrong and hard to notice in the UI: price updates and sorting in Domain, message encoding and the connection state in PriceFeed and Networking.

Unit tests don't use the network. The socket is behind a protocol, feed tests use millisecond intervals instead of waiting for real seconds. Tests against the real echo server are in the `Integration` plan since they need network. CI runs it as a separate step.

The `UI` plan has one test that walks the main flow: start the feed, open a symbol, go back, sort, stop. It doesn't check prices or "Connected", so it passes even when the echo server is slow. CI runs it last.

```bash
xcodebuild test -project LiveStocks.xcodeproj -scheme LiveStocks -testPlan Unit \
	-destination 'platform=iOS Simulator,name=iPhone 17,OS=latest'
```

Same command with `-testPlan Integration` or `-testPlan UI` runs the other plans.
