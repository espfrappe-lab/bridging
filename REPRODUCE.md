# Reproduction Instructions

This document explains how to regenerate all reported results from scratch using the
source documentation and the two skills provided in this package.

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| **Claude Code** | CLI — `claude` command must be available in your shell |
| **Git** | To clone the target SDK repository |
| **Dart SDK ≥ 3.0 + Flutter** | Only needed if you want to *run* the generated tests |

The pipeline is driven entirely through Claude Code slash commands. No other tools
are required.

---

## Setup

### 1. Clone both repositories

```bash
git clone https://github.com/espfrappe-lab/bridging.git replication-package
git clone https://github.com/Soneso/stellar_flutter_sdk.git
cd stellar_flutter_sdk
```

### 2. Install the skills

Copy both skill directories into the project's `.claude/skills/` folder:

```bash
mkdir -p .claude/skills
cp -r ../replication-package/skills/doc-to-tests   .claude/skills/
cp -r ../replication-package/skills/test-coverage-eval .claude/skills/
```

### 3. Copy supporting DATA files

The skills reference the topic index and test-classification map:

```bash
mkdir -p DATA/pipeline
cp ../replication-package/coverage/topics.md            DATA/topics.md
cp ../replication-package/benchmark/test_classification.csv DATA/test_classification.csv
```

### 4. Open Claude Code in the repo root

```bash
claude
```

---

## Running the pipeline (per subtopic)

Each subtopic requires two commands: one to generate all five artifact stages, and one
to evaluate coverage against the benchmark.

### Stage generation: `/doc-to-tests`

```
/doc-to-tests

Use subtopic <ID> <Name> as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.
```

Outputs written to `DATA/pipeline/<subtopic-dir>/`:

| File | Stage |
|------|-------|
| `01-user-stories.md` | 1 — User Stories |
| `02-acceptance-criteria.md` | 2 — Acceptance Criteria |
| `03-gherkin-scenarios.md` | 3 — Gherkin Scenarios |
| `04-test-specifications.md` | 4 — Test Specifications |
| `05-traceability-table.md` | 5 — Traceability Table |

The executable test script is written to `test/docsTest/sdk_usage_<subtopic>_test.dart`.

### Coverage evaluation: `/test-coverage-eval`

```
/test-coverage-eval

Evaluate the doc-to-tests output in test/docsTest/sdk_usage_<subtopic>_test.dart
against the benchmark suite specified in test_classification.csv
using documentation/sdk-usage.md as the source of truth.

The full artifact trail — user stories, acceptance criteria, Gherkin scenarios,
test specifications, test script, and traceability table — is written to
DATA/pipeline/<subtopic-dir>/

Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1
and RQ2. Save the matrix as CSV in DATA
```

Output: `DATA/coverage_matrix_<subtopic>.csv`

---

## Full command list (all 10 study subtopics)

### 1.1 Creating Keypairs

```
/doc-to-tests
Use subtopic 1.1 Creating Keypairs as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_1_1_creating_keypairs_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/1.1-creating-keypairs/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

### 1.2 Loading an Account

```
/doc-to-tests
Use subtopic 1.2 Loading an Account as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_1_2_loading_an_account_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/1.2-loading-an-account/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

### 1.3 Funding Testnet Accounts

```
/doc-to-tests
Use subtopic 1.3 Funding Testnet Accounts as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_1_3_funding_testnet_accounts_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/1.3-funding-testnet-accounts/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

### 1.4 HD Wallets (SEP-5)

```
/doc-to-tests
Use subtopic 1.4 HD Wallets (SEP-5) as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_1_4_hd_wallets_sep5_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/1.4-hd-wallets-sep5/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

### 1.5 Muxed Accounts

```
/doc-to-tests
Use subtopic 1.5 Muxed Accounts as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_1_5_muxed_accounts_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/1.5-muxed-accounts/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

### 1.6 Connecting to Networks

```
/doc-to-tests
Use subtopic 1.6 Connecting to Networks as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_1_6_connecting_to_networks_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/1.6-connecting-to-networks/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

### 2.1 Simple Payments

```
/doc-to-tests
Use subtopic 2.1 Simple Payments as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_2_1_simple_payments_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/2.1-simple-payments/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

### 2.2 Multi-Operation Transactions

```
/doc-to-tests
Use subtopic 2.2 Multi-Operation Transactions as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_2_2_multi_operation_transactions_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/2.2-multi-operation-transactions/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

### 2.3 Memos, Time Bounds, and Fees

```
/doc-to-tests
Use subtopic 2.3 Memos, Time Bounds, and Fees as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_2_3_memos_time_bounds_fees_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/2.3-memos-time-bounds-fees/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

### 2.4 Fee Bump Transactions

```
/doc-to-tests
Use subtopic 2.4 Fee Bump Transactions as specified in /DATA/topics.md of /documentation/sdk-usage.md
Target: Dart + flutter_test unit tests. Full pipeline.

/test-coverage-eval
Evaluate the doc-to-tests output in test/docsTest/sdk_usage_2_4_fee_bump_transactions_test.dart against the benchmark suite specify in test_classification.csv
using documentation/sdk-usage.md as the source of truth.
The full artifact trail — user stories, acceptance criteria, Gherkin scenarios, test specifications, test script, and traceability table — is written to DATA/pipeline/2.4-fee-bump-transactions/
Count per subtopic, assign alignment verdicts, check traceability, and answer RQ1 and RQ2. Save the matrix as CSV in DATA
```

---

## Comparing your results to the reported results

After running all 10 subtopics, your `DATA/coverage_matrix_*.csv` files can be
compared directly to the matrices in `coverage/` in this package.

The key columns are:

| Column | Meaning |
|--------|---------|
| `rq1_covered` | YES/NO — was the acceptance criterion covered by a generated test? (RQ1) |
| `rq2_aligned` | YES/NO/N/A — does it align with the benchmark? (RQ2) |
| `alignment_verdict` | ALIGNED / PARTIAL / MISSING / EXTRA / UNTESTABLE |

Aggregate the `rq1_covered` and `rq2_aligned` counts per subtopic and compare to
the summaries in `coverage/summary_1_1_to_1_6.md` and `coverage/summary_2_1_to_2_4.md`.

---

## Running the generated tests

The generated test files are standard Dart `flutter_test` unit tests and can be run
with the Flutter test runner from the SDK repo root:

```bash
flutter test test/docsTest/sdk_usage_1_1_creating_keypairs_test.dart
# or all at once:
flutter test test/docsTest/
```

Most tests make live calls to the Stellar testnet via Horizon and Friendbot, so an
internet connection is required. Tests that fund accounts via Friendbot may be
rate-limited if run in rapid succession.
