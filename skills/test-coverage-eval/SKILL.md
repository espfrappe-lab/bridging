---
name: test-coverage-eval
description: >-
  Evaluate test artifacts generated from documentation (e.g. by the doc-to-tests
  pipeline) against the documentation and manually-written benchmark test suite, organized by documentation topic and subtopic, to measure how well the generated artifacts cover documented functionality and align with the benchmark. Use this skill
  whenever the user wants to evaluate or assess generated tests, compare generated
  artifacts to a benchmark or reference/existing test suite, answer research questions
  about coverage (RQ1 documentation coverage / RQ2 benchmark alignment), build a
  coverage matrix, quantify requirement traceability, or analyze how well generated
  tests reconstruct the functionality in the docs — even if
  they just say "evaluate the tests my framework produced" or "how well do these tests
  cover the documentation." Compares at the topic/subtopic level, not by source-code
  diffing. Pairs with the doc-to-tests skill.
---

# Test Coverage Evaluation

## Purpose

Assess a documentation-driven test-generation framework by comparing its generated
artifacts to a manually-developed **benchmark** test suite. The evaluation is
deliberately **not** a line-by-line source comparison. It works at the level of
documented functionality — topics and subtopics — and asks whether the generated
artifacts reconstruct the same coverage the benchmark provides, while remaining fully
traceable to the documentation.

The point is *coverage reconstruction* and *requirement traceability*, the primary
objectives of the framework. Two tests can look nothing alike in code yet exercise the
same documented behavior; conversely, similar-looking code can test different things.
So compare what functionality is covered, not how the code reads.

## The two research questions

Frame every evaluation around these, and answer each explicitly:

- **RQ1 — Documentation coverage.** To what extent can the framework transform the
  functionality described in the SDK Usage Guide into all five artifact types (user
  stories, acceptance criteria, Gherkin scenarios, test specifications, executable
  tests)? Coverage is measured against *both* the documented topic hierarchy *and* the
  corresponding benchmark tests.
- **RQ2 — Coverage alignment.** How closely do the generated artifacts align with the
  manually-developed benchmark tests — does the framework reconstruct the same
  *functional* coverage the existing suite represents? Compared at the topic/subtopic
  level, not by source-code diffing.

## Inputs you need

1. **Documentation** — the source of truth, which defines the topic/subtopic structure.
2. **Generated artifacts** — ideally the full doc-to-tests chain (user stories,
   acceptance criteria, Gherkin scenarios, test specs, executable tests). If only the
   final tests exist, evaluate what's available and note the limitation.
3. **Benchmark suite** — the manually-written tests treated as the reference (e.g. an
   SDK's existing `/test` directory).

If any input is missing, say so and scope the evaluation to what's present rather than
inventing the missing side.

## Method

### Step 1 — Build the topic/subtopic skeleton from the docs

use the csv provided in `DATA/test_classification.csv` if available, or build it yourself by reviewing the documentation and listing its topics and subtopics.

Derive the comparison units from the documentation's own structure. Top-level sections
are **topics**; the capabilities within them are **subtopics**. Use the docs' headings,
not the test files' organization — the docs are the fixed coordinate system both sides
are measured against. List every subtopic, even ones you suspect neither side covers
(those still matter for RQ1 — documented functionality nothing addresses).

### Step 2 — Record counts per subtopic

For each subtopic, count and tabulate:

- benchmark tests
- generated user stories
- generated acceptance criteria
- generated Gherkin scenarios
- generated test specifications
- generated executable tests

Count by mapping each item to the subtopic it exercises, not by where it physically
lives. A benchmark test file may cover several subtopics; split its count accordingly.
When the benchmark is real code, prefer counting programmatically (e.g. enumerate
`test(...)` / `it(...)` / `@Test` / `def test_*` and attribute each to a subtopic) and
show your counting method so it's reproducible.

### Step 3 — Judge coverage alignment per subtopic

For each subtopic, decide whether the generated artifacts address the **same documented
functionality** as the benchmark, and assign one verdict:

- **Aligned** — generated artifacts cover the same functionality the benchmark tests
  (counts may differ; functionality matches).
- **Partial** — generated artifacts cover some but not all of the benchmark's
  functionality for this subtopic (under-coverage).
- **Generated-only** — generated artifacts cover documented functionality the benchmark
  does **not** test. Either a genuine benchmark gap (valuable) or an
  over-generation/hallucination (must be flagged). Distinguish the two by checking the
  artifact's traceability back to the docs.
- **Benchmark-only** — the benchmark tests functionality the framework failed to
  generate. An RQ1/RQ2 weakness.
- **Uncovered** — documented functionality neither side addresses.

Decide alignment by matching acceptance criteria / scenario intent to what each
benchmark test asserts — semantic match of behavior, not code similarity.

### Step 4 — Verify traceability

For a sample (or all) generated tests, confirm the chain holds:
`doc → user story → acceptance criterion → scenario → spec → test`. Report the share of
generated tests that trace cleanly to a documented requirement. Generated tests that
trace to nothing are the hallucination signal that qualifies any Generated-only verdict.

### Step 5 — Answer the RQs from the table

- **RQ1:** report transformation success across all five artifact types, and coverage
  two ways — generated subtopics ÷ documented subtopics (vs. the topic hierarchy) *and*
  generated subtopics that match a benchmarked subtopic (vs. the benchmark). Note where
  generation was thin or stalled between stages.
- **RQ2:** distribution of alignment verdicts on shared subtopics (Aligned / Partial /
  Benchmark-only), with examples; an overall characterization of how well functional
  coverage is reconstructed. Note any Generated-only subtopics and whether they trace
  cleanly to the docs.

## Output format

ALWAYS produce, in this order:

1. **Coverage matrix** — one row per subtopic, the six counts, and the alignment
   verdict:

   | Topic | Subtopic | Bench tests | User stories | Acc. criteria | Gherkin | Specs | Exec tests | Verdict |

2. **Per-topic rollup** — totals and verdict mix per topic.
3. **RQ1 / RQ2 findings** — each answered explicitly with numbers from the matrix
   and concrete examples.
4. **Traceability summary** — share of generated tests with a clean chain; list orphans.
5. **Limitations** — missing inputs, judgment calls on ambiguous subtopic mapping, any
   counting caveats.

Keep verdicts evidence-backed: cite the subtopic and what each side does, not just a
label. Save the matrix as a file (CSV or Markdown table) the user can sort and audit.

Verdict vocabulary (alignment, use exactly these): `Aligned`, `Partial`,
`Generated-only`, `Benchmark-only`, `Uncovered`.

See `references/worked-example.md` for a filled-in evaluation across a few subtopics
and the recommended CSV schema for the matrix.

Write 3 paragraphs summarizing the findings, and then output the full matrix for RQ1 and RQ2 in markdown format.