# Stage 5 — Traceability Table
## Subtopic 1.4: HD Wallets (SEP-5)

| Doc claim | US | AC | Scenario | Spec | Generated test | Benchmark coverage |
|---|---|---|---|---|---|---|
| `generate24WordsMnemonic()` is async | US-01 | AC-01.1 | SC-01.1 | TS-01.1 | TS-01.1 (async test) | implicit (benchmark awaits call) |
| Returns a non-empty string | US-01 | AC-01.2 | SC-01.1 | TS-01.1 | TS-01.1 — `isNotEmpty` | implicit |
| Returned string has exactly 24 words | US-01 | AC-01.3 | SC-01.1 | TS-01.1 | TS-01.1 — `split(' ').length == 24` | `expect(mnemonic.split(' ').length, 24)` |
| Mnemonic generation is random (unique) | US-01 | AC-01.4 | SC-01.2 | TS-01.2 | TS-01.2 — `m1 != m2` | not tested |
| `Wallet.from(mnemonic)` returns a Wallet | US-02 | AC-02.1 | SC-02.1 | TS-02.1 | TS-02.1 — `isNotNull` | implicit (wallet used in benchmark) |
| `getKeyPair(index)` returns a KeyPair | US-02 | AC-02.2 | SC-02.2 | TS-02.2 | TS-02.2 — `isNotNull` | implicit |
| Derived accountId starts with G | US-02 | AC-02.3 | SC-02.2 | TS-02.2 | TS-02.2 — `startsWith('G')` | `expect(account0.accountId, startsWith('G'))` |
| Different indices → different accountIds | US-02 | AC-02.4 | SC-02.3 | TS-02.3 | TS-02.3 — `kp0 != kp1` | `expect(account0.accountId, isNot(account1.accountId))` |
| Same mnemonic → same accounts (determinism) | US-02 | AC-02.5 | SC-02.4 | TS-02.4 | TS-02.4 — `kp0Again == kp0` | `expect(account0Again.accountId, account0.accountId)` |
| Derived keypair can sign | US-02 | AC-02.6 | SC-02.5 | TS-02.5 | TS-02.5 — `canSign() == true` | not tested |
| `Wallet.from(mnemonic, passphrase:)` returns a Wallet | US-03 | AC-03.1 | SC-03.1 | TS-03.1 | TS-03.1 — wallet used implicitly | implicit |
| Passphrase → completely different accounts | US-03 | AC-03.2 | SC-03.1 | TS-03.1 | TS-03.1 — `kpWith != kpNo` | `expect(withPass.accountId, isNot(noPass.accountId))` |
| Same mnemonic + passphrase is deterministic | US-03 | AC-03.3 | SC-03.2 | TS-03.2 | TS-03.2 — `kp1 == kp2` | not tested |

---

## Coverage summary
- **3 user stories**, all fully covered.
- **13 ACs** → **9 tests** (some ACs combined into one test where they share the same action).
- **0 orphan assertions** — every test traces to an AC.
- **4 ACs tested for the first time** (not in benchmark): AC-01.4, AC-02.6, AC-03.3, and explicit AC-02.1/AC-02.2 non-null checks.

## Coverage gaps
| Gap | Reason |
|---|---|
| Index boundary / negative index errors (AMB-2) | Not documented; tests use only indices 0 and 1 |
| Cross-SDK BIP-39 test vectors (AMB-3) | No test vectors provided in documentation |
| Security advisory (AMB-4) | Informational text, not an API behavior |
