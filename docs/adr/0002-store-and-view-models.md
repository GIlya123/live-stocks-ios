# 2. Shared store, view model only where there is logic

## Context

Prices have to update on the list and on the details screen at the same time. The list has logic worth testing (sorting, resort throttling, Start/Stop), the details screen only displays a quote.

## Decision

`QuoteStore` is the single source of truth. It subscribes to the feed and holds one `@Observable` object per symbol, `LiveQuote`. A tick changes one object, so one row is redrawn. Both screens read the same objects, which is why they stay in sync without extra code.

`SymbolsListViewModel` exists because the list has logic: it keeps rows sorted, resorts once a second so rows don't jump on every tick, and toggles the feed. The details screen has no view model, it takes a `LiveQuote` and renders it. If it grows logic, it gets a view model then.

`QuoteStore` lives in `Domain` for now. It depends only on `PriceStreaming` and both screens already depend on `Domain`. If the store grows, it moves to its own module.

## Considered

- MVVM everywhere. A details view model would only pass a quote through.
- Views reading the store directly with no view models. Sorting and throttling would end up either in the view or in the shared store.
- Store in the SwiftUI environment. Equally valid, passing it explicitly keeps dependencies visible. Easy to switch if deep navigation needs it.
