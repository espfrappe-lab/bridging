# Stage 5 — Traceability Table
## Subtopic 1.6: Connecting to Networks

| Doc claim | US | AC | Scenario | Spec | Generated test | Benchmark coverage |
|---|---|---|---|---|---|---|
| `StellarSDK.TESTNET` returns an SDK instance | US-01 | AC-01.1 | SC-01.1 | TS-01.1 | TS-01.1 — `isNotNull` | `expect(testnet, isNotNull)` (sdk-usage + getting-started) |
| `Network.TESTNET` returns a Network object | US-01 | AC-01.2 | SC-01.2 | TS-01.2 | TS-01.2 — `isNotNull` | `expect(Network.TESTNET, isNotNull)` (sdk-usage + getting-started) |
| `StellarSDK.PUBLIC` returns an SDK instance | US-02 | AC-02.1 | SC-02.1 | TS-02.1 | TS-02.1 — `isNotNull` | `expect(pubnet, isNotNull)` (sdk-usage + getting-started) |
| `Network.PUBLIC` returns a Network object | US-02 | AC-02.2 | SC-02.2 | TS-02.2 | TS-02.2 — `isNotNull` | `expect(Network.PUBLIC, isNotNull)` (sdk-usage + getting-started) |
| `StellarSDK.FUTURENET` returns an SDK instance | US-03 | AC-03.1 | SC-03.1 | TS-03.1 | TS-03.1 — `isNotNull` | `expect(futurenet, isNotNull)` (sdk-usage only) |
| `Network.FUTURENET` returns a Network object | US-03 | AC-03.2 | SC-03.2 | TS-03.2 | TS-03.2 — `isNotNull` | `expect(Network.FUTURENET, isNotNull)` (sdk-usage only) |
| `StellarSDK("url")` accepts a custom HTTPS URL | US-04 | AC-04.1 | SC-04.1 | TS-04.1 | TS-04.1 — `isNotNull` | `expect(custom, isNotNull)` (sdk-usage + getting-started) |
| Each network has its own passphrase (distinctness) | US-01/02/03 | AC-05.1 | SC-05.1 | TS-05.1 | TS-05.1 — three `isNot(equals(...))` checks | not tested |

---

## Coverage summary

- **4 user stories**, all fully covered.
- **9 ACs → 8 tests** (AC-05.1 produces one test with three assertions; AC-01.1 + AC-01.2 produce individual tests, etc.).
- **0 orphan assertions** — every test traces to an AC.
- **1 AC tested for the first time** (not in benchmark): AC-05.1 (network distinctness invariant).

## Coverage gaps

| Gap | Reason |
|---|---|
| Invalid URL constructor behavior (AMB-1) | Not documented; only valid URL tested |
| Network passphrase used in signing (TL-1) | Signing is a separate subtopic (§ Simple Payments) |
| Futurenet SDK/Network absent from getting-started tests | Getting-started doc does not cover Futurenet; no gap in sdk-usage coverage |
