# 1. Local Swift package, no external tools

## Context

The reviewer should be able to clone, open and run. The app still needs module boundaries that would hold up in a team.

## Decision

One local package, `LiveStocksKit`, with a target per module. The Xcode project is a thin shell that links the package products. No Tuist, no SwiftLint, no third-party code. Formatting is `swift-format` from the Xcode toolchain, with the config in `.swift-format`.

Protocols sit where their users are. `PriceStreaming` is in `Domain`, so screens depend on `Domain` and the networking code is swapped underneath. There is no separate API module for the feed, one module would have held three types.

## Considered

- Tuist. Good at team scale, but the reviewer would have to install it. Mentioned here as the next step if the project grows.
- SwiftLint. Extra install and a second config to keep in sync with the formatter. `swift-format` alone covers what matters here.
- A `PriceFeedAPI` module. Would decouple compile times of the feed from the screens, but a module for a protocol and two enums is more than this project needs.
