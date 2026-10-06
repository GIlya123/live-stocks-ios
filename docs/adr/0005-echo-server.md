# 5. Echo server instead of a market feed

## Context

The assignment asks to connect to `wss://ws.postman-echo.com/raw`, generate price updates and render what comes back. There is no real market data.

## Decision

The app is both the producer and the consumer. `PriceGenerator` does a random walk, up to 1% per step, rounded to cents. `LivePriceFeed` sends the ticks and publishes the echoes. The generator sits in `PriceFeed/Simulation` to make clear it stands in for the market.

What would change with a real feed: the generator and the send loop go away, after connect the feed sends one subscription message and only receives. The message format follows the provider. Everything else stays: transport, reconnects, epoch, sequence numbers, the store and the screens.

## Considered

- Faking the feed without a server. Would skip the WebSocket part the assignment is about.
- Keeping the generator behind a protocol for a future swap. The real feed removes the generator rather than replacing it, a protocol would guard a seam that never gets used.
