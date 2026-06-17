# Replication Package

This replication package supports the paper:

Bridging Documentation and Testing with Large Language Models: A Structured Pipeline for Test Generation

---

##
## Contents

```
replication-package/
├── documentation/          # 1. Source documentation used in the study
│   └── sdk-usage.md
├── benchmark/              # 2. Manually-written benchmark test suite
│   ├── test_classification.csv
│   └── tests/
├── artifacts/              # 3. Generated intermediate artifacts (full pipeline)
│   ├── pipeline/           #    Per-topic artifact trail (Stages 1–5)
│   │   ├── 1.1-creating-keypairs/
│   │   ├── 1.2-loading-an-account/
│   │   ├── 1.3-funding-testnet-accounts/
│   │   ├── 1.4-hd-wallets-sep5/
│   │   ├── 1.5-muxed-accounts/
│   │   ├── 1.6-connecting-to-networks/
│   │   ├── 2.1-simple-payments/
│   │   ├── 2.2-multi-operation-transactions/
│   │   ├── 2.3-memos-time-bounds-fees/
│   │   └── 2.4-fee-bump-transactions/
│   └── generated-tests/    #    Executable test scripts (Stage 5 output)
├── coverage/               #    Coverage matrices and evaluation summaries
│   ├── topics.md
│   ├── coverage_matrix_1_1.csv … coverage_matrix_2_4.csv
│   ├── summary_1_1_to_1_6.md
│   ├── summary_2_1_to_2_4.md
│   └── changelog.md
└── skills/                 # 4. Skills and instructions for reproduction
    ├── doc-to-tests/
    │   ├── SKILL.md
    │   └── references/worked-example.md
    └── test-coverage-eval/
        ├── SKILL.md
        └── references/worked-example.md
```

---

## Quick orientation

### 1. Source documentation (`documentation/`)

`sdk-usage.md` is the Stellar Flutter SDK Usage Guide used as the sole input to the
doc-to-tests pipeline. It defines the topic and subtopic hierarchy studied in the
paper (see `coverage/topics.md` for the full index).

### 2. Benchmark test suite (`benchmark/`)

The `tests/` directory contains the manually-written test suite that serves as the
reference for evaluation. `test_classification.csv` maps each benchmark test to the
documentation topic and subtopic it covers.

### 3. Generated artifacts (`artifacts/`)

Each subdirectory under `artifacts/pipeline/` corresponds to one documentation
subtopic and contains the five intermediate artifacts produced by the pipeline:

| File | Stage | Content |
|------|-------|---------|
| `01-user-stories.md` | Stage 1 | User stories derived from the documentation |
| `02-acceptance-criteria.md` | Stage 2 | Acceptance criteria for each user story |
| `03-gherkin-scenarios.md` | Stage 3 | BDD Gherkin scenarios |
| `04-test-specifications.md` | Stage 4 | Detailed test specifications |
| `05-traceability-table.md` | Stage 5 | Traceability from assertions back to docs |

`artifacts/generated-tests/` contains the executable Dart test scripts (Stage 5
output) for each subtopic.

`coverage/` contains the per-subtopic coverage matrices (RQ1 and RQ2) and evaluation
summaries.

### 4. Skills (`skills/`)

`skills/doc-to-tests/SKILL.md` — the prompt-based pipeline instruction used to drive
the LLM through all five stages of test generation.

`skills/test-coverage-eval/SKILL.md` — the evaluation protocol used to assess
documentation coverage (RQ1) and benchmark alignment (RQ2).

Both skills include a `references/worked-example.md` with a concrete illustration of
the pipeline and evaluation in action.

---

## Reproducing the study

See [REPRODUCE.md](REPRODUCE.md) for step-by-step instructions.
