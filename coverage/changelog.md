# Changelog

## 2026-06-15 — TL-1 Testnet-Only Test (1.3 Funding Testnet Accounts)

### Problem
TL-1 ("Only works on testnet — mainnet fails") was marked **UNTESTABLE** because the original pipeline assumed proving it required calling FriendBot against mainnet, incurring real XLM costs. On closer inspection, `FriendBot.fundTestAccount()` uses a hardcoded `https://friendbot.stellar.org` URL, so a fresh random keypair funded by FriendBot will never appear on mainnet. The constraint is verifiable by a **read-only mainnet Horizon lookup** — no mainnet XLM spent.

### What changed

#### `test/docsTest/sdk_usage_1_3_funding_testnet_accounts_test.dart`
- Added **TS-TL-1** — funds a fresh account via FriendBot, asserts it exists on testnet (`StellarSDK.TESTNET`), then asserts the same account ID throws on mainnet (`StellarSDK.PUBLIC`). Proves FriendBot is testnet-only.

#### `DATA/pipeline/1.3-funding-testnet-accounts/02-acceptance-criteria.md`
- TL-1 note updated: marked as upgraded to **AC-TL-1** with the testable formulation.

#### `DATA/pipeline/1.3-funding-testnet-accounts/03-gherkin-scenarios.md`
- Added **SC-TL-1** Gherkin scenario.

#### `DATA/pipeline/1.3-funding-testnet-accounts/04-test-specifications.md`
- Added **TS-TL-1** test specification; updated testability limitations table to mark TL-1 as upgraded.

#### `DATA/coverage_matrix_1_3.csv`
- TL-1 row updated:
  - `ac_id`: `(TL-1)` → `(TL-1 → AC-TL-1)`
  - `generated_test`: references TS-TL-1 with approach description.
  - `alignment_verdict`: `UNTESTABLE` → `ALIGNED`
  - `rq1_covered`: `NO` → `YES`
  - `rq2_aligned`: `N/A` (unchanged — benchmark has no equivalent test)

---

## 2026-06-15 — AC-06.2 Atomicity Rollback Test (2.2 Multi-Operation Transactions)

### Problem
AC-06.2 ("all operations execute atomically; if any fails the entire transaction rolls back") was marked **UNTESTABLE** in the pipeline because the original doc-to-tests run only considered the documented positive example and did not construct a deliberately failing transaction.

### What changed

#### `test/docsTest/sdk_usage_2_2_multi_operation_transactions_test.dart`
- Removed stale comment on TS-06.1 that described rollback as UNTESTABLE.
- Added **TS-06.2** — a new test that:
  - Builds a two-operation transaction: a valid `CreateAccountOperation` (Op 1) followed by a `PaymentOperation` of 50,000 native XLM (Op 2), which exceeds the FriendBot-funded balance of ~10,000 XLM.
  - Submits to testnet and asserts `response.success == false`.
  - Confirms the new account was **not** created on Horizon (`expectLater(..., throwsA(anything))`), proving Op 1 was rolled back when Op 2 failed.

#### `DATA/pipeline/2.2-multi-operation-transactions/03-gherkin-scenarios.md`
- Added **SC-06.2** — Gherkin scenario for the atomicity rollback path.

#### `DATA/pipeline/2.2-multi-operation-transactions/04-test-specifications.md`
- Replaced the "Notes on AC-06.2 (UNTESTABLE)" section with a full **TS-06.2** test specification including objective, preconditions, test data, steps, assertions, and oracle.

#### `DATA/coverage_matrix_2_2.csv`
- AC-06.2 row updated:
  - `generated_test`: now references TS-06.2 with description of the approach.
  - `alignment_verdict`: `UNTESTABLE` → `ALIGNED`
  - `rq1_covered`: `NO` → `YES`
  - `rq2_aligned`: `N/A` (unchanged — benchmark has no equivalent negative test)
