# Stage 3 — Gherkin Scenarios
## Subtopic 1.1: Creating Keypairs
**Source:** Stage 2 acceptance criteria

---

## Feature: Generating a random Stellar keypair (US-01)

```gherkin
Scenario: SC-01.1 — Random keypair returns a non-null object
  Given the stellar_flutter_sdk is available
  When a developer calls KeyPair.random()
  Then a non-null KeyPair object shall be returned

Scenario: SC-01.2 — Random keypair public key starts with G
  Given the stellar_flutter_sdk is available
  When a developer calls KeyPair.random()
  Then the accountId shall start with "G"
  And the accountId shall not be empty

Scenario: SC-01.3 — Random keypair secret seed starts with S
  Given the stellar_flutter_sdk is available
  When a developer calls KeyPair.random()
  Then the secretSeed shall start with "S"
  And the secretSeed shall not be empty

Scenario: SC-01.4 — Random keypairs are unique
  Given the stellar_flutter_sdk is available
  When a developer calls KeyPair.random() twice in succession
  Then the two resulting accountId values shall be different
  And the two resulting secretSeed values shall be different

Scenario: SC-01.5 — Random keypair can sign
  Given the stellar_flutter_sdk is available
  When a developer calls KeyPair.random()
  Then canSign() shall return true
```

---

## Feature: Creating a keypair from an existing secret seed (US-02)

```gherkin
Scenario: SC-02.1 — Valid secret seed returns a non-null KeyPair
  Given the stellar_flutter_sdk is available
  And a valid Stellar secret seed string beginning with "S"
  When a developer calls KeyPair.fromSecretSeed(seed)
  Then a non-null KeyPair object shall be returned

Scenario: SC-02.2 — Secret seed round-trip consistency
  Given a valid Stellar secret seed string
  When a developer calls KeyPair.fromSecretSeed(seed)
  Then the returned keypair's secretSeed property shall equal the input seed string

Scenario: SC-02.3 — Keypair derivation from seed is deterministic
  Given a known Stellar secret seed with a known corresponding account ID
  When a developer calls KeyPair.fromSecretSeed(seed)
  Then the returned keypair's accountId shall equal the expected account ID
  And calling KeyPair.fromSecretSeed() a second time with the same seed shall produce the same accountId

Scenario: SC-02.4 — Keypair from seed can sign
  Given a valid Stellar secret seed string
  When a developer calls KeyPair.fromSecretSeed(seed)
  Then canSign() on the returned keypair shall return true

Scenario: SC-02.5 — Invalid secret seed throws FormatException
  Given the stellar_flutter_sdk is available
  When a developer calls KeyPair.fromSecretSeed() with a malformed string
  Then a FormatException shall be thrown
```

---

## Feature: Creating a public-key-only keypair from an account ID (US-03)

```gherkin
Scenario: SC-03.1 — Valid account ID returns a non-null KeyPair
  Given the stellar_flutter_sdk is available
  And a valid Stellar account ID string beginning with "G"
  When a developer calls KeyPair.fromAccountId(accountId)
  Then a non-null KeyPair object shall be returned

Scenario: SC-03.2 — Public-key-only keypair preserves the account ID
  Given a valid Stellar account ID string
  When a developer calls KeyPair.fromAccountId(accountId)
  Then the returned keypair's accountId property shall equal the input account ID

Scenario: SC-03.3 — Public-key-only keypair cannot sign
  Given a valid Stellar account ID string
  When a developer calls KeyPair.fromAccountId(accountId)
  Then canSign() on the returned keypair shall return false

Scenario: SC-03.4 — Invalid account ID throws FormatException
  Given the stellar_flutter_sdk is available
  When a developer calls KeyPair.fromAccountId() with a malformed string
  Then a FormatException shall be thrown
```
