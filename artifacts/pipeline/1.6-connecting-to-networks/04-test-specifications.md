# Stage 4 — Test Specifications
## Subtopic 1.6: Connecting to Networks
**Source:** `documentation/sdk-usage.md` § "Connecting to Networks"

---

## TS-01 group — Testnet (US-01)

### TS-01.1 — StellarSDK.TESTNET is non-null

- **Objective:** Verify that `StellarSDK.TESTNET` is available and returns a usable object.
- **Scenario:** SC-01.1
- **Preconditions:** `stellar_flutter_sdk` package imported.
- **Test data:** n/a (no input)
- **Execution steps:** Access `StellarSDK.TESTNET`.
- **Expected outcome:** A non-null `StellarSDK` instance is returned.
- **Assertions:** `expect(StellarSDK.TESTNET, isNotNull)`
- **Postconditions:** n/a

---

### TS-01.2 — Network.TESTNET is non-null

- **Objective:** Verify that the Testnet network passphrase constant is available.
- **Scenario:** SC-01.2
- **Preconditions:** `stellar_flutter_sdk` package imported.
- **Test data:** n/a
- **Execution steps:** Access `Network.TESTNET`.
- **Expected outcome:** A non-null `Network` object is returned.
- **Assertions:** `expect(Network.TESTNET, isNotNull)`
- **Postconditions:** n/a

---

## TS-02 group — Public network (US-02)

### TS-02.1 — StellarSDK.PUBLIC is non-null

- **Objective:** Verify that `StellarSDK.PUBLIC` is available and returns a usable object.
- **Scenario:** SC-02.1
- **Preconditions:** `stellar_flutter_sdk` package imported.
- **Test data:** n/a
- **Execution steps:** Access `StellarSDK.PUBLIC`.
- **Expected outcome:** A non-null `StellarSDK` instance is returned.
- **Assertions:** `expect(StellarSDK.PUBLIC, isNotNull)`
- **Postconditions:** n/a

---

### TS-02.2 — Network.PUBLIC is non-null

- **Objective:** Verify that the Public network passphrase constant is available.
- **Scenario:** SC-02.2
- **Preconditions:** `stellar_flutter_sdk` package imported.
- **Test data:** n/a
- **Execution steps:** Access `Network.PUBLIC`.
- **Expected outcome:** A non-null `Network` object is returned.
- **Assertions:** `expect(Network.PUBLIC, isNotNull)`
- **Postconditions:** n/a

---

## TS-03 group — Futurenet (US-03)

### TS-03.1 — StellarSDK.FUTURENET is non-null

- **Objective:** Verify that `StellarSDK.FUTURENET` is available and returns a usable object.
- **Scenario:** SC-03.1
- **Preconditions:** `stellar_flutter_sdk` package imported.
- **Test data:** n/a
- **Execution steps:** Access `StellarSDK.FUTURENET`.
- **Expected outcome:** A non-null `StellarSDK` instance is returned.
- **Assertions:** `expect(StellarSDK.FUTURENET, isNotNull)`
- **Postconditions:** n/a

---

### TS-03.2 — Network.FUTURENET is non-null

- **Objective:** Verify that the Futurenet network passphrase constant is available.
- **Scenario:** SC-03.2
- **Preconditions:** `stellar_flutter_sdk` package imported.
- **Test data:** n/a
- **Execution steps:** Access `Network.FUTURENET`.
- **Expected outcome:** A non-null `Network` object is returned.
- **Assertions:** `expect(Network.FUTURENET, isNotNull)`
- **Postconditions:** n/a

---

## TS-04 group — Custom Horizon server (US-04)

### TS-04.1 — StellarSDK constructor accepts a custom URL

- **Objective:** Verify that `StellarSDK(url)` accepts any HTTPS URL string without throwing.
- **Scenario:** SC-04.1
- **Preconditions:** `stellar_flutter_sdk` package imported.
- **Test data:** `"https://my-horizon-server.example.com"` (the exact example from the documentation)
- **Execution steps:** Call `StellarSDK("https://my-horizon-server.example.com")`.
- **Expected outcome:** A non-null `StellarSDK` instance is returned.
- **Assertions:** `expect(StellarSDK("https://my-horizon-server.example.com"), isNotNull)`
- **Postconditions:** n/a

---

## TS-05 group — Cross-cutting invariant (AC-05.1)

### TS-05.1 — Network constants are mutually distinct

- **Objective:** Verify that each named network has a distinct identity, consistent
  with the doc's claim that each network has "its own… network passphrase."
- **Scenario:** SC-05.1
- **Preconditions:** All three `Network` constants available.
- **Test data:** `Network.TESTNET`, `Network.PUBLIC`, `Network.FUTURENET`
- **Execution steps:** Compare each pair using `!=`.
- **Expected outcomes:** All three pairs are unequal.
- **Assertions:**
  ```dart
  expect(Network.TESTNET, isNot(equals(Network.PUBLIC)));
  expect(Network.TESTNET, isNot(equals(Network.FUTURENET)));
  expect(Network.PUBLIC,  isNot(equals(Network.FUTURENET)));
  ```
- **Postconditions:** n/a

---

## Test oracle summary

| TS | Oracle type | What it guards |
|---|---|---|
| TS-01.1 | Functional | TESTNET SDK instance available |
| TS-01.2 | Functional | TESTNET Network constant available |
| TS-02.1 | Functional | PUBLIC SDK instance available |
| TS-02.2 | Functional | PUBLIC Network constant available |
| TS-03.1 | Functional | FUTURENET SDK instance available |
| TS-03.2 | Functional | FUTURENET Network constant available |
| TS-04.1 | Functional | Custom URL constructor works |
| TS-05.1 | Invariant | Three networks are mutually distinct per-passphrase |
