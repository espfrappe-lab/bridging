# Summary: Section 2 — Building Transactions (Subtopics 2.1–2.4)

## Coverage Table

| # | Subtopic | Total ACs | ALIGNED | EXPANDED | Not Covered | RQ1 | Notes |
|---|---|---:|---:|---:|---:|---:|---|
| 2.1 | Simple Payments | 13 | 4 | 9 | 0 | 100% | 1 undocumented benchmark behavior skipped (BENCHMARK-ONLY) |
| 2.2 | Multi-Operation Transactions | 14 | 2 | 11 | 1 | 93% | 1 UNTESTABLE (atomicity rollback); generated tests use 3 ops (per docs), benchmark uses 2 |
| 2.3 | Memos / Time Bounds / Fees | 16 | 6 | 10 | 0 | 100% | — |
| 2.4 | Fee Bump Transactions | 9 | 1 | 8 | 0 | 100% | Generated tests use 2-op inner tx (per docs); benchmark uses 1-op |
| **Total** | | **52** | **13** | **38** | **1** | **98%** | |

> **ALIGNED** = the generator replicated every assertion the benchmark makes for that subtopic (100% benchmark alignment in all four cases). **EXPANDED** = documented behaviors the generator tested that the benchmark does not cover. **Not Covered** = behaviors that cannot be exercised in a unit/integration test (UNTESTABLE) or where the generator contradicts the benchmark (DIVERGENT); none here except the single atomicity rollback in 2.2.

---

## Description

The generated test suite covered 51 of 52 documented behaviors across the four transaction-building subtopics, achieving a 98% RQ1 score. The one uncovered behavior is the atomicity rollback guarantee in 2.2 (AC-06.2): the documentation states that all operations in a multi-operation transaction either succeed together or all fail, but exercising the failure side would require deliberately constructing an invalid operation — something outside the scope of a documentation-driven unit test. All remaining 51 behaviors were exercised across 22 generated tests spanning builder contracts, signing workflows, and end-to-end network submissions. RQ1 was 100% for three of the four subtopics; only 2.2 fell to 93% due to that single untestable rollback path.

Benchmark alignment was 100% across all four subtopics: every explicit assertion in the four benchmark tests (`response.success`, the memo round-trip type and text checks, and fee bump success) was replicated exactly by at least one generated test. The ALIGNED count appears small (13 of 52) because the benchmark concentrates on the happy-path submission result — a single `response.success == true` assertion for 2.2 and 2.4, and four assertions total for 2.3 (memo type and text). The 38 EXPANDED ACs reflect the documentation's richer scope: alternative memo types (`Memo.id`, `Memo.hash`, `Memo.returnHash`), the fee bump base-fee formula (`100 × inner_ops + 100 = 300` minimum), `TimeBounds` and `setMaxOperationFee` builder no-throw contracts, transaction structure invariants (`operations.length == 3`), and the dual-signing pattern where inner and fee-bump transactions each require a different keypair. In two subtopics the generated tests deliberately follow the documentation over the benchmark: 2.2 uses a three-operation transaction (create account + trustline + payment, as documented) rather than the benchmark's two-operation shortcut, and 2.4 uses a two-operation inner transaction to exercise the documented fee formula rather than the benchmark's single-operation simplification.
