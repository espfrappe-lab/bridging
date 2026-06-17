# Stage 4 — Test Specifications
## Subtopic 1.5: Muxed Accounts
**Source:** `documentation/sdk-usage.md` § "Muxed Accounts"

---

## TS-01 group — Construct a MuxedAccount (US-01)

### TS-01.1 — Constructor returns a non-null object

- **Objective:** Verify that `MuxedAccount(address, id)` succeeds and produces a non-null value.
- **Scenario:** SC-01.1
- **Preconditions:** None (purely local call; `KeyPair.random().accountId` provides a valid G-address).
- **Test data:**
  - `baseAddress` = `KeyPair.random().accountId` (a fresh G-prefixed Stellar address)
  - `userId` = `BigInt.from(123456789)`
- **Execution steps:**
  1. Generate `baseAddress` via `KeyPair.random().accountId`.
  2. Call `MuxedAccount(baseAddress, userId)`.
- **Expected outcome:** The constructor does not throw; the returned object is non-null.
- **Assertions:** `expect(muxedAccount, isNotNull)`
- **Postconditions:** n/a

---

### TS-01.2 — accountId begins with 'M'

- **Objective:** Verify that the encoded muxed address uses the M-prefix specified by the docs.
- **Scenario:** SC-01.2
- **Preconditions:** `muxedAccount` is a `MuxedAccount` constructed with a valid G-address and `BigInt.from(123456789)`.
- **Test data:** same `baseAddress` and `userId` as TS-01.1 (shared setup).
- **Execution steps:**
  1. Read `muxedAccount.accountId`.
- **Expected outcome:** The string starts with the letter `'M'`.
- **Assertions:** `expect(muxedAccount.accountId, startsWith('M'))`
- **Postconditions:** n/a

---

### TS-01.3 — .id round-trips the numeric ID

- **Objective:** Verify that `.id` returns exactly the `BigInt` that was passed to the constructor.
- **Scenario:** SC-01.3
- **Preconditions:** `muxedAccount` constructed as above.
- **Test data:** `BigInt.from(123456789)` as test value (exact value from documentation example).
- **Execution steps:**
  1. Read `muxedAccount.id`.
- **Expected outcome:** Equals `BigInt.from(123456789)`.
- **Assertions:** `expect(muxedAccount.id, equals(BigInt.from(123456789)))`
- **Postconditions:** n/a

---

### TS-01.4 — .ed25519AccountId round-trips the base G-address

- **Objective:** Verify that `.ed25519AccountId` returns exactly the G-address that was passed to the constructor.
- **Scenario:** SC-01.4
- **Preconditions:** `muxedAccount` constructed from `baseAddress`.
- **Test data:** `baseAddress` (same G-address used in TS-01.1 setup).
- **Execution steps:**
  1. Read `muxedAccount.ed25519AccountId`.
- **Expected outcome:** Equals `baseAddress`.
- **Assertions:** `expect(muxedAccount.ed25519AccountId, equals(baseAddress))`
- **Postconditions:** n/a

---

## TS-02 group — Parse an M-address (US-02)

> **Setup (shared across TS-02.x):**
> 1. Generate `baseAddress = KeyPair.random().accountId`.
> 2. Construct `muxedAccount = MuxedAccount(baseAddress, BigInt.from(123456789))`.
> 3. Store `mAddress = muxedAccount.accountId`.
> 4. Parse `parsed = MuxedAccount.fromAccountId(mAddress)`.
>
> All four specs in this group share one `setUpAll` that runs these four steps.

---

### TS-02.1 — fromAccountId() returns non-null for a valid M-address

- **Objective:** Verify that `fromAccountId()` accepts a valid M-address and returns a non-null object.
- **Scenario:** SC-02.1
- **Preconditions:** `mAddress` is an M-address obtained from a valid MuxedAccount.
- **Test data:** `mAddress` from shared setup.
- **Execution steps:** (already done in setUpAll) — assert directly.
- **Expected outcome:** `parsed` is non-null.
- **Assertions:** `expect(parsed, isNotNull)`
- **Postconditions:** n/a

---

### TS-02.2 — Parsed object recovers original base G-address

- **Objective:** Verify the encoding/decoding round-trip for the base G-address.
- **Scenario:** SC-02.2
- **Preconditions:** `parsed` is a successfully parsed `MuxedAccount`.
- **Test data:** `baseAddress` from shared setup; `parsed` from shared setup.
- **Execution steps:**
  1. Read `parsed!.ed25519AccountId`.
- **Expected outcome:** Equals `baseAddress`.
- **Assertions:** `expect(parsed!.ed25519AccountId, equals(baseAddress))`
- **Postconditions:** n/a

---

### TS-02.3 — Parsed object recovers original numeric ID

- **Objective:** Verify the encoding/decoding round-trip for the 64-bit user ID.
- **Scenario:** SC-02.3
- **Preconditions:** `parsed` is a successfully parsed `MuxedAccount`.
- **Test data:** `BigInt.from(123456789)`; `parsed` from shared setup.
- **Execution steps:**
  1. Read `parsed!.id`.
- **Expected outcome:** Equals `BigInt.from(123456789)`.
- **Assertions:** `expect(parsed!.id, equals(BigInt.from(123456789)))`
- **Postconditions:** n/a

---

### TS-02.4 — Parsed object's accountId is self-consistent with input M-address

- **Objective:** Verify that the parsed object reproduces the same M-address string.
- **Scenario:** SC-02.4
- **Preconditions:** `parsed` is a successfully parsed `MuxedAccount`; `mAddress` is the input.
- **Test data:** `mAddress` from shared setup.
- **Execution steps:**
  1. Read `parsed!.accountId`.
- **Expected outcome:** Equals `mAddress`.
- **Assertions:** `expect(parsed!.accountId, equals(mAddress))`
- **Postconditions:** n/a

---

## TS-03 group — Use M-address in a payment (US-03)

### TS-03.1 — PaymentOperationBuilder accepts an M-address without throwing

- **Objective:** Verify that an M-address is a valid destination for `PaymentOperationBuilder`.
- **Scenario:** SC-03.1
- **Preconditions:** A `MuxedAccount` has been constructed and its `.accountId` (an M-address) obtained.
- **Test data:**
  - `mAddress` = `muxedAccount.accountId` (M-address from a fresh `KeyPair.random()` base)
  - asset = `Asset.NATIVE`
  - amount = `"100"`
- **Execution steps:**
  1. Generate `baseAddress = KeyPair.random().accountId`.
  2. Construct `muxedAccount = MuxedAccount(baseAddress, BigInt.from(123456789))`.
  3. Read `mAddress = muxedAccount.accountId`.
  4. Call `PaymentOperationBuilder(mAddress, Asset.NATIVE, "100").build()`.
- **Expected outcome:** No exception is thrown; `build()` returns a non-null `Operation`.
- **Assertions:**
  ```dart
  final op = PaymentOperationBuilder(mAddress, Asset.NATIVE, "100").build();
  expect(op, isNotNull);
  ```
- **Postconditions:** n/a (no network call; purely local builder)

---

## Test oracle summary

| TS | Oracle type | What it guards |
|---|---|---|
| TS-01.1 | Functional | Constructor success |
| TS-01.2 | Data integrity / Format | M-prefix encoding per spec |
| TS-01.3 | Data integrity / Round-trip | 64-bit ID fidelity through constructor |
| TS-01.4 | Data integrity / Round-trip | G-address fidelity through constructor |
| TS-02.1 | Functional | Parser handles valid input without error |
| TS-02.2 | Data integrity / Round-trip | G-address survives encode→decode |
| TS-02.3 | Data integrity / Round-trip | 64-bit ID survives encode→decode |
| TS-02.4 | Data integrity / Self-consistency | M-address is stable through a parse cycle |
| TS-03.1 | Functional / Protocol compliance | M-address accepted by payment builder |
