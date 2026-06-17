# Worked Example: One Capability Through All Five Stages

This walks a single capability — creating a Stellar keypair — from a documentation
snippet all the way to executable tests, so you can see the full chain and the level
of detail expected at each stage. The target here is **Dart + `flutter_test`**; adapt
Stage 5 to whatever the user picked.

---

## Source documentation (input)

> Every Stellar account has a keypair: a public key (the account ID, starts with G)
> and a secret seed (starts with S). The secret seed signs transactions.
> `KeyPair.random()` generates a new random keypair. `KeyPair.fromSecretSeed(seed)`
> creates one from an existing secret seed. `KeyPair.fromAccountId(id)` creates a
> public-key-only keypair that cannot sign.

---

## Stage 1 — User Stories

- **US-01:** As a developer, I want to generate a new random keypair so that I can
  create a fresh Stellar identity.
- **US-02:** As a developer, I want to reconstruct a keypair from a secret seed so
  that I can sign with an existing account.
- **US-03:** As a developer, I want a public-key-only keypair so that I can represent
  an account I cannot sign for.

(The rest of the example follows US-01.)

---

## Stage 2 — Acceptance Criteria (US-01)

- **AC-01.1** A public key (account ID) starting with `G` shall be generated.
- **AC-01.2** A secret seed starting with `S` shall be generated.
- **AC-01.3** The account ID shall be a valid StrKey-encoded ed25519 public key.
- **AC-01.4** The secret seed shall be a valid StrKey-encoded ed25519 seed.
- **AC-01.5** Two successive calls shall produce different keypairs (randomness).
- **AC-01.6** A keypair reconstructed from the generated seed shall reproduce the
  same account ID (round-trip integrity).

---

## Stage 3 — Gherkin Scenarios (US-01)

```gherkin
Scenario: Generate a valid random keypair
  Given the SDK is available
  When a developer generates a random keypair
  Then the account ID should start with "G"
  And the secret seed should start with "S"
  And the account ID should pass StrKey public-key validation
  And the secret seed should pass StrKey seed validation

Scenario: Random keypairs are unique
  Given the SDK is available
  When a developer generates two keypairs in succession
  Then the two account IDs should differ
  And the two secret seeds should differ

Scenario: Seed round-trips to the same account
  Given a generated random keypair
  When a developer rebuilds a keypair from its secret seed
  Then the rebuilt account ID should equal the original account ID
```

---

## Stage 4 — Test Specification (Scenario: "Generate a valid random keypair")

- **ID:** TS-01.1
- **Objective:** Verify `KeyPair.random()` produces a structurally valid, format-
  conformant Stellar keypair.
- **Preconditions:** SDK imported; no network required (pure local crypto).
- **Test data:** none (generation is parameterless).
- **Execution steps:**
  1. Call `KeyPair.random()`.
  2. Read `accountId` and `secretSeed`.
- **Expected outcomes:** A keypair object with a populated account ID and secret seed.
- **Assertions:**
  - `accountId` is non-empty and starts with `G`.
  - `secretSeed` is non-empty and starts with `S`.
  - `accountId` length is 56 (StrKey ed25519 public key).
  - `secretSeed` length is 56 (StrKey ed25519 seed).
- **Oracles (domain correctness):**
  - *Protocol rule:* account ID is decodable as a StrKey ed25519 public key
    (checksum valid).
  - *Data integrity:* rebuilding from `secretSeed` yields the identical `accountId`.
  - *State invariant:* the same secret seed always maps to one account ID.
- **Postconditions:** none (no external state mutated).

---

## Stage 5 — Test Script (Dart / `flutter_test`)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

void main() {
  group('KeyPair.random() — US-01', () {
    // Trace: US-01 → AC-01.1/.2/.3/.4 → SC "valid random keypair" → TS-01.1
    test('produces a format-valid, StrKey-conformant keypair', () {
      final kp = KeyPair.random();

      // AC-01.1 / AC-01.2 — prefixes
      expect(kp.accountId, startsWith('G'));
      expect(kp.secretSeed, startsWith('S'));

      // AC-01.3 / AC-01.4 — StrKey length/format
      expect(kp.accountId.length, 56);
      expect(kp.secretSeed.length, 56);

      // Oracle (protocol rule) — account ID decodes as a valid ed25519 public key
      expect(() => KeyPair.fromAccountId(kp.accountId), returnsNormally);
    });

    // Trace: US-01 → AC-01.5 → SC "random keypairs are unique"
    test('successive keypairs are unique', () {
      final a = KeyPair.random();
      final b = KeyPair.random();
      expect(a.accountId, isNot(equals(b.accountId)));
      expect(a.secretSeed, isNot(equals(b.secretSeed)));
    });

    // Trace: US-01 → AC-01.6 → SC "seed round-trips to the same account"
    test('seed round-trips to the same account ID (data integrity oracle)', () {
      final original = KeyPair.random();
      final rebuilt = KeyPair.fromSecretSeed(original.secretSeed);
      expect(rebuilt.accountId, equals(original.accountId));
    });
  });
}
```

Notes that generalize:
- Each `test` carries a trace comment back to its IDs — that is the traceability
  contract made concrete in code.
- Assertions map 1:1 to acceptance criteria; the *oracles* (round-trip, StrKey
  decode) are what make this more than a smoke test.
- This capability needed no network, so no `setUp`/`tearDown`. A capability like
  "send a payment" would, in this SDK, add `FriendBot.fundTestAccount()` in setup and
  poll Horizon in assertions — keep that environment-specific cost in mind when the
  target is integration-level.

---

## Traceability table (deliverable)

| User Story | Acceptance Criteria        | Scenario                       | Spec    | Test                                   |
|------------|----------------------------|--------------------------------|---------|----------------------------------------|
| US-01      | AC-01.1, .2, .3, .4        | Generate a valid random keypair| TS-01.1 | `produces a format-valid… keypair`     |
| US-01      | AC-01.5                    | Random keypairs are unique     | TS-01.2 | `successive keypairs are unique`       |
| US-01      | AC-01.6                    | Seed round-trips…              | TS-01.3 | `seed round-trips to the same…`        |

Hand a table like this back with the tests so the user can see coverage at a glance
and catch any acceptance criterion that never became a test.
