# LiveStocks

Real-time stock prices for 25 symbols over a WebSocket echo server.
Test assignment for MultiBank Group.

## Requirements

- Xcode 27
- iOS 17+

No third-party dependencies. Open `LiveStocks.xcodeproj` and run the `LiveStocks` scheme.

## Tests

```bash
xcodebuild test -project LiveStocks.xcodeproj -scheme LiveStocks -testPlan Unit \
	-destination 'platform=iOS Simulator,name=iPhone 17,OS=latest'
```

Testing approach is in [TESTING.md](TESTING.md). Modules live in `Packages/LiveStocksKit`.
