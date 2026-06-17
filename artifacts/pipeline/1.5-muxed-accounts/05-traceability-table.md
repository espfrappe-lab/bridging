# Stage 5 — Traceability Table
## Subtopic 1.5: Muxed Accounts

| Doc claim | US | AC | Scenario | Spec | Generated test | Benchmark coverage |
|---|---|---|---|---|---|---|
| `MuxedAccount(addr, id)` returns a non-null object | US-01 | AC-01.1 | SC-01.1 | TS-01.1 | TS-01.1 — `isNotNull` | implicit (object used in benchmark) |
| `.accountId` returns M-prefixed string | US-01 | AC-01.2 | SC-01.2 | TS-01.2 | TS-01.2 — `startsWith('M')` | not tested explicitly |
| `.id` returns the exact BigInt passed in | US-01 | AC-01.3 | SC-01.3 | TS-01.3 | TS-01.3 — `equals(BigInt.from(123456789))` | `expect(muxedAccount.id, BigInt.from(123456789))` |
| `.ed25519AccountId` returns the base G-address | US-01 | AC-01.4 | SC-01.4 | TS-01.4 | TS-01.4 — `equals(baseAddress)` | `expect(muxedAccount.ed25519AccountId, account1.accountId)` |
| `MuxedAccount.fromAccountId(mAddr)` returns non-null | US-02 | AC-02.1 | SC-02.1 | TS-02.1 | TS-02.1 — `isNotNull` | `expect(parsed, isNotNull)` |
| Parsed `.ed25519AccountId` equals original G-address | US-02 | AC-02.2 | SC-02.2 | TS-02.2 | TS-02.2 — `equals(baseAddress)` | `expect(parsed!.ed25519AccountId, account1.accountId)` |
| Parsed `.id` equals original BigInt | US-02 | AC-02.3 | SC-02.3 | TS-02.3 | TS-02.3 — `equals(BigInt.from(123456789))` | `expect(parsed.id, BigInt.from(123456789))` |
| Parsed `.accountId` equals the input M-address | US-02 | AC-02.4 | SC-02.4 | TS-02.4 | TS-02.4 — `equals(mAddress)` | not tested explicitly |
| `PaymentOperationBuilder(mAddr, …).build()` succeeds | US-03 | AC-03.1 + AC-03.2 | SC-03.1 | TS-03.1 | TS-03.1 — `isNotNull` | not tested (benchmark omits payment builder) |

---

## Coverage summary

- **3 user stories**, all fully covered.
- **9 ACs → 9 tests** (one test per AC; AC-03.1 and AC-03.2 share TS-03.1 because the only observable outcome is a single `.build()` call).
- **0 orphan assertions** — every test traces to an AC.
- **2 ACs tested for the first time** (not in benchmark): AC-01.2 (M-prefix), AC-02.4 (self-consistency), and US-03 entirely.

## Coverage gaps

| Gap | Reason |
|---|---|
| Invalid-address path for `fromAccountId()` (AMB-2) | Not documented; only happy path is specified |
| 64-bit boundary values (AMB-3) | Only the example value `123456789` is mentioned in docs |
| Payment destination validation (network) | Benchmark test does not fund or submit; builder is tested locally only |
