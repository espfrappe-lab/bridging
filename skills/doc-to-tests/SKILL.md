---
name: doc-to-tests
description: >-
  Transform software documentation (SDK guides, API references, tutorials, technical
  specs, developer manuals) into executable automated test scripts through a structured
  five-stage pipeline: User Stories → Acceptance Criteria → Gherkin Scenarios → Test
  Specifications → Test Scripts. Use this skill whenever the user wants to generate
  tests from documentation, create a test suite or test cases from a spec or API
  reference, derive test scenarios from requirements, write BDD/Gherkin scenarios, or
  turn docs into test automation — even if they only say "write tests for this
  SDK/API/doc" without naming the pipeline. Supports multiple languages and platforms
  (unit, widget, integration, API, end-to-end testing).
---

# Doc-to-Tests: Structured LLM Test Generation

## Purpose

Generate trustworthy automated tests from documentation by passing through a sequence
of progressively-refined intermediate artifacts instead of jumping straight from docs
to code. Each stage is a checkpoint that constrains the next, which reduces
hallucination, prevents requirements from being silently dropped, and produces an
auditable trail from every assertion back to the sentence in the docs that motivated
it.

Direct "docs → test code" generation tends to invent behavior the docs never claimed,
skip requirements, and produce tests no one can trace or trust. This pipeline narrows
the solution space at each step and leaves room for human review between stages.

## The Pipeline

```
Documentation
  ↓  Stage 1
User Stories
  ↓  Stage 2
Acceptance Criteria
  ↓  Stage 3
Gherkin Scenarios
  ↓  Stage 4
Test Specifications
  ↓  Stage 5
Executable Test Scripts
```

Run the stages in order. Treat each stage's output as the *only* input to the next
stage (plus the original docs for grounding) — this is what keeps the chain
traceable. Do not skip ahead to code; the intermediate artifacts are the point.

Do not use information from existing tests or prior knowledge of the system to fill in gaps in the documentation. The goal is to generate tests *solely* from the provided documentation, so any assumptions or guesses about behavior that is not explicitly stated in the docs should be avoided. If the documentation is incomplete or ambiguous, flag those issues and ask the user for clarification rather than inventing behavior.

## Before you start: scope it

Ask the user (or infer from context) three things, then proceed:

1. **Source** — which doc/section/file is the source of truth? If a section is huge,
   work one capability cluster at a time rather than the whole manual at once.
2. **Target** — language + framework + test layer (e.g. Dart + `flutter_test` widget
   test, Python + pytest API test, JS + WebdriverIO e2e). This determines Stage 5
   output and some Stage 4 detail.
3. **Depth** — full pipeline with all intermediate artifacts written out, or a
   condensed run where you show the artifacts inline and emphasize the final scripts.

If the user already handed you a partial artifact (e.g. existing acceptance criteria),
enter the pipeline at that stage instead of restarting from Stage 1.

Assign a **stable ID** to each item as it is created and carry it forward
(`US-01` → `AC-01.3` → `SC-01.3` → `TS-01.3`). IDs are the backbone of traceability.

---

## Stage 1 — User Stories

Read the documentation and extract functional capabilities from the perspective of an
end user or system actor. Output one user story per distinct capability, using:

```
As a [role], I want [functionality], so that [business or technical objective].
```

Keep stories atomic — one capability each. A "create keypair" story and a "load an
account" story are separate even if documented in the same section. Preserve the
intent of the source; do not invent capabilities the docs don't describe.

**Example**
> **US-01:** As a developer, I want to create a Stellar keypair so that I can
> authenticate blockchain transactions.

---

## Stage 2 — Acceptance Criteria

Expand each user story into a set of observable, verifiable conditions. Cover all of:

- **Functional requirements** — what the feature must do
- **Validation rules** — constraints on inputs/outputs
- **Preconditions** — what must be true before the action
- **Error conditions** — how invalid inputs / failure states behave
- **Expected outcomes** — the success result

Phrase each as a checkable statement ("A valid public key shall be generated"), not a
vague goal. These criteria become the constraints that everything downstream must
satisfy, so be exhaustive about edge and error cases here — that is where naive
generation usually goes thin.

**Example (US-01)**
- AC-01.1 A valid public key (account ID) shall be generated.
- AC-01.2 A corresponding secret seed shall be generated.
- AC-01.3 Generated keys shall conform to Stellar address formats (G… / S…).
- AC-01.4 Invalid inputs to keypair construction shall return appropriate errors.

---

## Stage 3 — Gherkin Scenarios

Turn each acceptance criterion (or a tight group of related criteria) into BDD
scenarios using Given / When / Then. Use `And` / `But` for additional clauses.

- **Given** — preconditions / setup
- **When** — the single action under test
- **Then** — the expected, observable outcomes (one or more)

Prefer one clear action per scenario. Use `Scenario Outline` with `Examples` tables
when the same behavior is checked across multiple data values. Keep the language
semi-formal: readable by non-technical stakeholders, parseable for automation.

**Example**
```gherkin
Scenario: Generate a valid Stellar keypair
  Given the SDK is initialized
  When a developer requests a new keypair
  Then a valid public key should be generated
  And a valid secret key should be generated
  And both keys should pass Stellar format validation
```

---

## Stage 4 — Test Specifications

Convert each Gherkin scenario into a detailed, language-agnostic specification — a
blueprint precise enough that someone could implement the test without re-reading the
docs. Each spec contains:

- **Objective** — what this test proves
- **Preconditions** — required state/setup
- **Test data** — concrete inputs (real values, not placeholders, where possible)
- **Execution steps** — ordered actions
- **Expected outcomes** — what should happen
- **Assertions** — the specific checks to make
- **Postconditions** — cleanup / resulting state

**Crucially, extract test oracles** — domain-specific correctness properties that go
beyond "did it return without throwing." These make the tests *meaningful*. Look for:

- **State invariants** — things that must always hold (e.g. balance never negative)
- **Data integrity constraints** — round-trip / format / referential consistency
- **Protocol validation rules** — spec-defined correctness (e.g. address checksums,
  envelope structure, threshold rules)
- **Error-handling requirements** — correct error type/code on each failure path
- **Business rules** — domain logic the docs imply

A spec with only "result is not null" assertions is a smell — go back to the docs and
the acceptance criteria and pull out the real oracles.

See `references/worked-example.md` for a complete filled-in specification.

---

## Stage 5 — Test Scripts

Convert each specification into executable test code **in the user's chosen language
and framework**. Map every assertion, expected outcome, and validation rule from the
spec directly onto an executable verification statement — do not silently drop or
merge them, and do not add assertions that no upstream artifact justifies.

Emphasize *behavior validation via the oracles*, not just a recording of user actions.
A generated script should include, as applicable:

- Functional assertions (the action produced the expected result)
- State validation (system state matches invariants afterward)
- Error-handling verification (failure paths raise the right errors)
- Data-integrity checks (round-trips, formats, consistency)
- Protocol-compliance checks (spec rules hold)
- Invariant verification (the oracles from Stage 4)

Report the number of tests of each category (functional, error-handling, invariant, etc.) to show the balance of the suite.

Match the idioms of the target framework (e.g. `test()`/`expect()` + `setUp`/`tearDown`
for `flutter_test`; `describe`/`it` for WebdriverIO/Jest; `@Test` + fixtures for JUnit;
`def test_*` + fixtures for pytest). Include a short traceability comment on each test
linking it back to its spec/criterion ID.

---

## Traceability & Validation (applies throughout)

Maintain the full chain so any assertion can be walked back to its origin:

```
Documentation → User Story → Acceptance Criteria → Gherkin → Test Spec → Test Script
```

- Carry IDs forward at every stage; never renumber.
- When you finish, produce a short **traceability table** mapping
  `US → AC → Scenario → Spec → Test` so the user can spot gaps and check coverage.
- If a generated assertion has no upstream justification, delete it or go add the
  missing upstream artifact — don't leave orphan checks.
- Flag any documentation ambiguity you had to resolve, and say how you resolved it,
  rather than quietly guessing.

This is the core discipline of the skill: the LLM is a *guided synthesis* engine here,
not a free generator. Constrained, validated, traceable outputs over clever guesses.

## Output format

Default to writing the artifacts to files (one per stage, or a single structured
document with clear stage sections) plus the final test script file(s) in the target
language, and finish with the traceability table. For a quick/condensed run, show the
intermediate artifacts inline and save only the final test files. Always make the
final test scripts available as real files the user can drop into their project.
