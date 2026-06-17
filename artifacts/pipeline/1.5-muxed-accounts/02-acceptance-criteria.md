# Stage 2 — Acceptance Criteria
## Subtopic 1.5: Muxed Accounts
**Source:** `documentation/sdk-usage.md` § "Muxed Accounts"

---

## US-01 — Construct a MuxedAccount

**AC-01.1** `MuxedAccount(baseAccountId, BigInt.from(n))` shall accept a valid
G-address and a `BigInt` and return a non-null object.

**AC-01.2** The constructed object's `.accountId` property shall return a string
beginning with `'M'`, consistent with the documentation's statement that *"the muxed
address (M...) encodes both the base account and a 64-bit user ID"*.

**AC-01.3** The constructed object's `.id` property shall return the exact `BigInt`
value passed to the constructor (round-trip integrity for the numeric ID).

**AC-01.4** The constructed object's `.ed25519AccountId` property shall return the
exact G-address string passed to the constructor (round-trip integrity for the base
account).

---

## US-02 — Parse an M-address

**AC-02.1** `MuxedAccount.fromAccountId(mAddress)` shall return a non-null
`MuxedAccount` when given a valid M-address string.

**AC-02.2** The parsed object's `.ed25519AccountId` shall equal the G-address that
was used to construct the M-address (round-trip: create → encode → parse → base
account recovered).

**AC-02.3** The parsed object's `.id` shall equal the `BigInt` ID that was used to
construct the M-address (round-trip: create → encode → parse → ID recovered).

**AC-02.4** The parsed object's `.accountId` shall equal the M-address string that
was fed into `fromAccountId()` (the address is self-consistent after a parse cycle).

---

## US-03 — Use muxed address in a payment

**AC-03.1** The M-address returned by `.accountId` shall be accepted as the
destination argument to `PaymentOperationBuilder` without throwing an exception.

**AC-03.2** Calling `.build()` on the constructed `PaymentOperationBuilder` shall
return a non-null `Operation`.

---

## Ambiguities and limitations flagged

**AMB-1 — Placeholder G-address in docs:** The documentation uses `"GABC..."` as a
placeholder. Tests use `KeyPair.random().accountId` to obtain a syntactically valid
G-address without requiring a funded account or network access.

**AMB-2 — Nullable return of fromAccountId():** The documentation shows the return
type as `MuxedAccount?`. The docs do not describe what happens when an invalid or
non-muxed address is passed. Only the valid-input path is tested (AC-02.1 through
AC-02.4); error-path behavior is not documented and therefore not tested.

**AMB-3 — 64-bit ID range:** The documentation states "64-bit user ID" but does not
specify min/max values beyond what a 64-bit unsigned integer implies. The test uses
`BigInt.from(123456789)` — the exact value shown in the documentation example.

**AMB-4 — Placeholder M-address in docs:** `"MABC..."` is a placeholder. The tests
derive a real M-address by first constructing a `MuxedAccount` and reading its
`.accountId`, then feeding that into `fromAccountId()`.
