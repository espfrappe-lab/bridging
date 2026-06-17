# Stage 3 — Gherkin Scenarios
## Subtopic 1.6: Connecting to Networks
**Source:** `documentation/sdk-usage.md` § "Connecting to Networks"

---

## US-01 — Testnet

```gherkin
Scenario SC-01.1: StellarSDK.TESTNET returns a non-null SDK instance
  Given the stellar_flutter_sdk package is imported
  When the developer accesses StellarSDK.TESTNET
  Then the result should be non-null

Scenario SC-01.2: Network.TESTNET returns a non-null Network object
  Given the stellar_flutter_sdk package is imported
  When the developer accesses Network.TESTNET
  Then the result should be non-null
```

---

## US-02 — Public (production) network

```gherkin
Scenario SC-02.1: StellarSDK.PUBLIC returns a non-null SDK instance
  Given the stellar_flutter_sdk package is imported
  When the developer accesses StellarSDK.PUBLIC
  Then the result should be non-null

Scenario SC-02.2: Network.PUBLIC returns a non-null Network object
  Given the stellar_flutter_sdk package is imported
  When the developer accesses Network.PUBLIC
  Then the result should be non-null
```

---

## US-03 — Futurenet

```gherkin
Scenario SC-03.1: StellarSDK.FUTURENET returns a non-null SDK instance
  Given the stellar_flutter_sdk package is imported
  When the developer accesses StellarSDK.FUTURENET
  Then the result should be non-null

Scenario SC-03.2: Network.FUTURENET returns a non-null Network object
  Given the stellar_flutter_sdk package is imported
  When the developer accesses Network.FUTURENET
  Then the result should be non-null
```

---

## US-04 — Custom Horizon server

```gherkin
Scenario SC-04.1: StellarSDK constructor accepts a custom HTTPS URL
  Given the developer has a custom Horizon server URL "https://my-horizon-server.example.com"
  When StellarSDK("https://my-horizon-server.example.com") is called
  Then the result should be non-null
  And no exception should be thrown
```

---

## Cross-cutting invariant (AC-05.1)

```gherkin
Scenario SC-05.1: The three Network constants are mutually distinct
  Given Network.TESTNET, Network.PUBLIC, and Network.FUTURENET are each available
  When they are compared to each other
  Then Network.TESTNET should not equal Network.PUBLIC
  And Network.TESTNET should not equal Network.FUTURENET
  And Network.PUBLIC should not equal Network.FUTURENET
```

---

## Notes

- All scenarios are synchronous and local — no network I/O required.
- Scenarios SC-01.x through SC-03.x are symmetric; they follow the same pattern for
  each of the three named networks.
- SC-05.1 is derived from the doc statement "each with its own… network passphrase"
  and is an invariant that spans all three US-01..03 objects.
