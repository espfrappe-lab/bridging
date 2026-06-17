# Stage 5 — Traceability Table
## Subtopic 1.3: Funding Testnet Accounts

| Doc claim | US | AC | Scenario | Spec | Generated test | Benchmark coverage |
|---|---|---|---|---|---|---|
| `FriendBot.fundTestAccount(accountId)` is async (await-able) | US-01 | AC-01.1 | SC-01.1 | TS-01.1 | TS-01.1 (async test, bare await) | implicit (benchmark uses `await`) |
| Accepts a valid G-address as input | US-01 | AC-01.2 | SC-01.1 | TS-01.1 | TS-01.1 (`kp.accountId` passed) | implicit |
| Account exists on testnet after the call | US-01 | AC-01.3 | SC-01.2 | TS-01.2 | TS-01.2 — AccountResponse not null | implicit (benchmark loads account in setUpAll) |
| Funded amount is approximately 10,000 XLM | US-01 | AC-01.4 | SC-01.3 | TS-01.3 | TS-01.3 — `closeTo(10000, 100)` | NOT tested in benchmark |
| Target must be a new (previously unfunded) account | US-01 | AC-01.5 | SC-01.1 | TS-01.1 | TS-01.1 (`KeyPair.random()` = fresh) | `KeyPair keyPair = KeyPair.random()` |
| Only works on testnet | US-01 | (TL-1) | — | — | not tested | not tested |

---

## Coverage gaps

| Gap | Reason | Mitigation |
|---|---|---|
| Return value of `fundTestAccount()` (AMB-1) | Doc shows bare `await`; return type not declared | Tests verify postcondition instead |
| Testnet-only constraint (TL-1) | Can't call mainnet FriendBot in a testnet suite | Documented as limitation |
| Re-funding behavior (TL-2) | Not described in docs | Out of scope |
