# Testing

Tests use Swift Testing. Each module has its own test target, all of them are in the `Unit` test plan with Thread Sanitizer on. CI runs it on every PR.

Unit tests focus on the logic that is easy to get wrong and hard to notice in the UI: price updates and sorting in Domain, message encoding and the connection state in PriceFeed and Networking.

Unit tests don't use the network or real time. The socket is behind a protocol and the clock is injected. Tests against the real echo server will go to a separate plan since they need network.

```bash
xcodebuild test -project LiveStocks.xcodeproj -scheme LiveStocks -testPlan Unit \
	-destination 'platform=iOS Simulator,name=iPhone 17,OS=latest'
```
