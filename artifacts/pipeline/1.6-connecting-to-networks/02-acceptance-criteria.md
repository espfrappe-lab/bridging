# Stage 2 — Acceptance Criteria
## Subtopic 1.6: Connecting to Networks
**Source:** `documentation/sdk-usage.md` § "Connecting to Networks"

---

## US-01 — Testnet

**AC-01.1** `StellarSDK.TESTNET` shall return a non-null `StellarSDK` instance
without throwing an exception.

**AC-01.2** `Network.TESTNET` shall return a non-null `Network` object without
throwing an exception.

---

## US-02 — Public (production) network

**AC-02.1** `StellarSDK.PUBLIC` shall return a non-null `StellarSDK` instance
without throwing an exception.

**AC-02.2** `Network.PUBLIC` shall return a non-null `Network` object without
throwing an exception.

---

## US-03 — Futurenet

**AC-03.1** `StellarSDK.FUTURENET` shall return a non-null `StellarSDK` instance
without throwing an exception.

**AC-03.2** `Network.FUTURENET` shall return a non-null `Network` object without
throwing an exception.

---

## US-04 — Custom Horizon server

**AC-04.1** `StellarSDK(url)` where `url` is a valid HTTPS URL string shall return
a non-null `StellarSDK` instance without throwing an exception.

---

## Cross-cutting invariant

**AC-05.1 — Network distinctness:** The three `Network` constants (`TESTNET`,
`PUBLIC`, `FUTURENET`) shall be mutually distinct, consistent with the documentation
statement that each network has *"its own… network passphrase."*

---

## Ambiguities and limitations flagged

**AMB-1 — Custom URL validation:** The documentation shows one custom URL
(`"https://my-horizon-server.example.com"`) but does not describe what happens when
an invalid or non-HTTPS URL is passed. Only the valid-URL path is tested.

**TL-1 — Passphrase used for signing:** The docs state *"The network passphrase is
used when signing transactions."* Actual signing is a separate operation (covered in
§ Simple Payments); this subtopic only tests that the Network constants are available
and distinct, not that they produce correct signatures.
