# 3. Money as Decimal, prices as strings on the wire

## Context

Change and percent change are computed from prices. With `Double`, 0.1 + 0.2 isn't 0.3, and the error shows up in the UI sooner or later.

## Decision

Prices are `Decimal` everywhere in the model. On the wire and in the catalog they are strings:

- `JSONDecoder` decodes `Decimal` through `Double`, so the JSON message carries the price as `"189.27"`.
- A `Decimal` literal in code also goes through `Double`, `227.48` becomes `227.4799999999999488`. Catalog prices are strings parsed in one place.

Prices are shown with Latin digits in every language. Exchange data and most finance apps in the region do the same, and Arabic-Indic digits would make prices hard to compare with other sources.

## Considered

- `Double` with rounding on display. Hides the problem instead of removing it.
- Prices in cents as integers in the catalog. Exact, but reads worse than `"227.48"` and ties the catalog to two decimal places.
