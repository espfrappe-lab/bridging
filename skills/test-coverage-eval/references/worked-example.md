# Worked Example: Evaluating Generated Tests Against a Benchmark

This shows the evaluation applied to a few subtopics, using the Stellar Flutter SDK
shape as the setting: the SDK usage guide is the **documentation**, the doc-to-tests
output is the **generated** side, and the SDK's existing `/test` directory is the
**benchmark**. Numbers here are illustrative — the point is the shape of the analysis.

---

## Step 1 — Topic/subtopic skeleton (from the docs)

Taken from the documentation headings, not the test files:

- **Topic: Keypairs & Accounts**
  - Creating keypairs
  - Loading an account
  - Funding testnet accounts
  - HD wallets (SEP-5)
  - Muxed accounts
- **Topic: Building Transactions**
  - Simple payments
  - Multi-operation transactions
  - Memos, time bounds, fees
  - Fee bump transactions

---

## Step 2 + 3 — Counts and verdict per subtopic

| Topic | Subtopic | Bench tests | User stories | Acc. criteria | Gherkin | Specs | Exec tests | Verdict |
|-------|----------|:-----------:|:------------:|:-------------:|:-------:|:-----:|:----------:|---------|
| Keypairs & Accounts | Creating keypairs | 4 | 3 | 14 | 8 | 8 | 9 | Aligned |
| Keypairs & Accounts | Loading an account | 2 | 1 | 5 | 3 | 3 | 3 | Aligned |
| Keypairs & Accounts | Funding testnet accounts | 3 | 1 | 4 | 2 | 2 | 2 | Partial |
| Keypairs & Accounts | HD wallets (SEP-5) | 0 | 2 | 9 | 5 | 5 | 6 | Generated-only |
| Keypairs & Accounts | Muxed accounts | 1 | 1 | 6 | 4 | 4 | 4 | Aligned |
| Building Transactions | Simple payments | 5 | 1 | 7 | 4 | 4 | 5 | Aligned |
| Building Transactions | Multi-operation transactions | 3 | 1 | 6 | 3 | 3 | 3 | Partial |
| Building Transactions | Memos, time bounds, fees | 4 | 3 | 12 | 7 | 7 | 5 | Partial |
| Building Transactions | Fee bump transactions | 2 | 1 | 6 | 3 | 3 | 3 | Aligned |

Counting method note: benchmark counts came from enumerating `test(...)` calls in the
relevant `*_test.dart` files and attributing each to the subtopic it exercises; a
single test asserting both memo and time-bound behavior was split 0.5/0.5 and rounded
in reporting (flagged in Limitations).

Verdict reasoning examples:
- *Funding testnet accounts → Partial:* benchmark exercises FriendBot success plus the
  "account already funded" and network-error paths (3 tests); generated artifacts cover
  only the happy path (AC for success, none for the error responses). Under-coverage of
  documented error behavior.
- *HD wallets → Generated-only:* the docs describe SEP-5 derivation and BIP-39
  passphrases, the framework generated 6 executable tests, but the benchmark has none.
  Traceability passes (every assertion maps to a documented SEP-5 rule), so this is a
  **genuine benchmark gap the framework exposed**, not a hallucination.
- *Memos, time bounds, fees → Partial:* generated specs cover all three memo
  permutations the docs list, but two scenarios about custom fee bounds never became
  executable tests (specs exist, exec tests missing) — a generation drop-off late in
  the pipeline.

---

## Step 4 — Traceability

Of 40 generated executable tests across these subtopics, 38 trace cleanly
`doc → US → AC → scenario → spec → test` (95%). The 2 orphans are both in
"Simple payments": assertions about a retry-on-`tx_bad_seq` behavior that the usage
guide does not describe at this subtopic. Flagged as unsupported — candidates for either
removal or relocation to an error-handling subtopic where the docs do cover it.

---

## Step 5 — Answering the research questions

**RQ1 — Documentation coverage.** All five artifact types were produced for every
subtopic that received generation. Coverage vs. the *topic hierarchy*: 9/9 documented
subtopics got artifacts. Coverage vs. the *benchmark*: 8/8 benchmarked subtopics were
matched. The 3 Partial subtopics show the framework reliably captures happy-path
functionality but thins out on documented error/edge behavior and occasionally loses
scenarios between spec and code generation.

**RQ2 — Coverage alignment.** On the 8 subtopics the benchmark covers: 5 Aligned, 3
Partial, 0 Benchmark-only. The framework reconstructs the benchmark's functional
coverage on a majority of shared subtopics; misalignment is consistently *under*-coverage
of error paths rather than testing the wrong functionality. One Generated-only subtopic
(HD wallets / SEP-5) covers documented functionality the benchmark omits, and it traces
cleanly to the docs — a real reconstruction the framework added rather than a
hallucination.

---

## Recommended matrix schema (CSV)

Save the matrix as CSV so it's sortable and auditable:

```csv
topic,subtopic,benchmark_tests,user_stories,acceptance_criteria,gherkin_scenarios,test_specs,executable_tests,verdict,notes
Keypairs & Accounts,Creating keypairs,4,3,14,8,8,9,Aligned,
Keypairs & Accounts,Funding testnet accounts,3,1,4,2,2,2,Partial,error paths not generated
Keypairs & Accounts,HD wallets (SEP-5),0,2,9,5,5,6,Generated-only,benchmark omits it; traceability clean
```

Verdict vocabulary (alignment, use exactly these): `Aligned`, `Partial`,
`Generated-only`, `Benchmark-only`, `Uncovered`. Keep `notes` short and evidence-bearing.