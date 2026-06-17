# Stage 2 — Acceptance Criteria
## Subtopic 1.1: Creating Keypairs
**Source:** Stage 1 user stories + `documentation/sdk-usage.md` § "Creating Keypairs"

---

## US-01: Generate a Random Keypair

- **AC-01.1** `KeyPair.random()` shall return a non-null `KeyPair` object.
- **AC-01.2** The `accountId` of the returned keypair shall be a non-empty string whose first character is `G`.
- **AC-01.3** The `secretSeed` of the returned keypair shall be a non-empty string whose first character is `S`.
- **AC-01.4** Two consecutive calls to `KeyPair.random()` shall produce keypairs with different `accountId` values and different `secretSeed` values (probabilistic uniqueness).
- **AC-01.5** A randomly-generated keypair shall be capable of signing (i.e., `canSign()` returns `true`).

---

## US-02: Create a Keypair from an Existing Secret Seed

- **AC-02.1** `KeyPair.fromSecretSeed(seed)` shall return a non-null `KeyPair` when given a valid Stellar secret seed string.
- **AC-02.2** The returned keypair's `secretSeed` property shall equal the input seed string (round-trip consistency).
- **AC-02.3** The returned keypair's `accountId` shall be determined solely by the input seed — the same seed shall always produce the same `accountId` (determinism).
- **AC-02.4** A keypair created from a secret seed shall be capable of signing (`canSign()` returns `true`).
- **AC-02.5** Passing a malformed or otherwise invalid string to `KeyPair.fromSecretSeed()` shall throw an error (the documentation implies input validation; the implementation throws `FormatException`).

---

## US-03: Create a Public-Key-Only Keypair from an Account ID

- **AC-03.1** `KeyPair.fromAccountId(accountId)` shall return a non-null `KeyPair` when given a valid Stellar account ID.
- **AC-03.2** The returned keypair's `accountId` property shall equal the input account ID string.
- **AC-03.3** A public-key-only keypair shall not be capable of signing (`canSign()` returns `false`).
- **AC-03.4** Passing a malformed or otherwise invalid string to `KeyPair.fromAccountId()` shall throw an error (the documentation implies input validation; the implementation throws `FormatException`).

---

## Ambiguities flagged

| ID | Ambiguity | Resolution |
|----|-----------|------------|
| AMB-1 | The docs do not specify the exact error type thrown on invalid inputs to `fromSecretSeed()` or `fromAccountId()`. | Confirmed via source: both throw `FormatException` (from `StrKey.decodeCheck`). Tests assert `throwsA(isA<FormatException>())`. |
| AMB-2 | The docs state public-key-only keypairs "cannot sign" but do not define what happens when `secretSeed` is accessed on them. | From source: accessing `secretSeed` on a public-key-only keypair throws a Dart null-check error (`_mPrivateKey!`). No test written for this; it is an undocumented side-effect. |
| AMB-3 | The docs' example seed (`SCZANGBA5YHTNYVVV3C7CAZMTQDBJHJG6C34JFD6XVEAEPTBED53FETV`) is not paired with its expected account ID in the documentation. | For the determinism test (AC-02.3), a different known-good seed/accountId pair is used — one established by the SDK's own unit tests — to avoid hardcoding an unverified oracle. |
