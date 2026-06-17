# Stage 5 — Traceability Table
## Subtopic 1.1: Creating Keypairs

| User Story | Acceptance Criterion | Gherkin Scenario | Test Spec | Test (file: `sdk_usage_1_1_creating_keypairs_test.dart`) |
|-----------|---------------------|-----------------|-----------|----------------------------------------------------------|
| US-01 | AC-01.1 | SC-01.1 | TS-01.1 | `TS-01.1 — returns a non-null KeyPair` |
| US-01 | AC-01.2 | SC-01.2 | TS-01.2 | `TS-01.2 — accountId is non-empty and starts with G` |
| US-01 | AC-01.3 | SC-01.3 | TS-01.3 | `TS-01.3 — secretSeed is non-empty and starts with S` |
| US-01 | AC-01.4 | SC-01.4 | TS-01.4 | `TS-01.4 — successive calls produce unique keypairs` |
| US-01 | AC-01.5 | SC-01.5 | TS-01.5 | `TS-01.5 — generated keypair can sign` |
| US-02 | AC-02.1 | SC-02.1 | TS-02.1 | `TS-02.1 — valid seed returns a non-null KeyPair` |
| US-02 | AC-02.2 | SC-02.2 | TS-02.2 | `TS-02.2 — secretSeed round-trips to the original input` |
| US-02 | AC-02.3 | SC-02.3 | TS-02.3 | `TS-02.3 — same seed always produces the same accountId (determinism)` |
| US-02 | AC-02.4 | SC-02.4 | TS-02.4 | `TS-02.4 — keypair from seed can sign` |
| US-02 | AC-02.5 | SC-02.5 | TS-02.5 | `TS-02.5a — malformed string throws FormatException` |
| US-02 | AC-02.5 | SC-02.5 | TS-02.5 | `TS-02.5b — account ID passed as seed throws FormatException` |
| US-02 | AMB-4 | — | — | `TS-02.5c — doc example seed (invalid checksum) throws FormatException` |
| US-03 | AC-03.1 | SC-03.1 | TS-03.1 | `TS-03.1 — valid account ID returns a non-null KeyPair` |
| US-03 | AC-03.2 | SC-03.2 | TS-03.2 | `TS-03.2 — accountId property equals the input string` |
| US-03 | AC-03.3 | SC-03.3 | TS-03.3 | `TS-03.3 — public-key-only keypair cannot sign` |
| US-03 | AC-03.4 | SC-03.4 | TS-03.4 | `TS-03.4a — malformed string throws FormatException` |
| US-03 | AC-03.4 | SC-03.4 | TS-03.4 | `TS-03.4b — secret seed passed as account ID throws FormatException` |

## Coverage summary

- **3 user stories** fully covered.
- **14 acceptance criteria** → **17 test cases** (2 criteria split into 2 tests each for distinct invalid-input variants; 1 bonus test for AMB-4).
- **0 orphan assertions** — every test traces back to a criterion or a flagged ambiguity.
- **0 undocumented features tested.**
- **All 17 tests pass.**

## Ambiguity log

| ID | Issue | Resolution |
|----|-------|------------|
| AMB-1 | Docs do not name the error type thrown on invalid inputs. | Source: `StrKey.decodeCheck()` throws `FormatException`. Tests use `isA<FormatException>()`. |
| AMB-2 | Docs say "cannot sign" but don't specify what accessing `secretSeed` on a public-key-only keypair does. | Not tested — this is undocumented behavior. `canSign()` is the documented capability predicate. |
| AMB-3 | The doc's example seed has no corresponding expected account ID in the documentation. | Determinism test (TS-02.3) uses a known SDK-verified seed/accountId pair instead. |
| AMB-4 | **Documentation defect:** The example seed `SCZANGBA5YHTNYVVV3C7CAZMTQDBJHJG6C34JFD6XVEAEPTBED53FETV` shown in the docs fails strkey checksum validation. | Tests TS-02.1/02.2/02.4 use a valid seed. TS-02.5c documents that the SDK correctly rejects the doc's example seed. The documentation should be corrected with a valid example seed. |
