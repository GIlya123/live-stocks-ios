# 4. How the feed stays correct

## Context

The feed runs across suspension points: connect, send, receive, sleep. The user can press Stop or switch region at any of them. The server can go quiet without closing the socket.

## Decision

`LivePriceFeed` is an actor, so there are no data races by construction. Logical races are handled with an epoch: every `start()` and `stop()` increments it, and the run loop checks it after each `await`. A run that outlived a Stop closes its connection and publishes nothing.

Every tick carries a sequence number. `StockQuote` applies a tick only if its number is higher than the last one, so a late echo can't move a price backwards.

A dead connection is detected by missing echoes: three sends without any message back and the connection is dropped. The app sends every two seconds anyway, a separate ping would be redundant.

Reconnects use doubling backoff with jitter, capped at 30 seconds. The ping used to confirm the handshake is cancellable, so a Stop during connect doesn't hang until the URLSession timeout.

The feed stops when the app goes to the background and starts again on return if it was running. iOS kills the socket on suspension, without this the user would come back to a stale screen waiting out the backoff.

## Considered

- Comparing tick timestamps instead of sequence numbers. Timestamps can collide or arrive out of order.
- A ping/pong heartbeat. Works, but adds a second timer next to the one that already sends prices.
- Giving up after N reconnect attempts. The user has a Stop button, the app shouldn't decide for them.
