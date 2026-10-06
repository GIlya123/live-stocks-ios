# 6. Regions and languages

## Context

The assignment wants an app ready for several regions. MultiBank is based in Dubai, so the second market is the UAE.

## Decision

A region is a market: which symbols to show and in which currency. `AppConfiguration` is built per region with its catalog, currency and feed URL. US stocks in USD, DFM and ADX stocks in AED. The user picks the region in the app, the choice is saved, and without a choice the device region is used. Switching rebuilds the container and the screens, and keeps the feed running if it was running.

Language is separate from region. It follows the iOS app language setting, the region picker links there. An expat in Dubai can watch the UAE market in English, and an Arabic speaker can follow US stocks in Arabic.

UI strings live in a string catalog inside each feature module and are read with `bundle: .module`. Company descriptions are not translated, in a real app they would come from an API.

## Considered

- Language tied to region. Wrong for both of the users above.
- A language switch inside the app. Common in the region, but system elements like the back button would stay in the system language. Possible later if the business asks for it.
- One shared `Localization` module with typed keys. Worth it when strings are shared between features. Today ten strings don't overlap.

## Not done

Backends per region, data residency, feature flags per region, market hours and local disclaimers. All of them hang off `AppConfiguration`, which is where they would be added.
