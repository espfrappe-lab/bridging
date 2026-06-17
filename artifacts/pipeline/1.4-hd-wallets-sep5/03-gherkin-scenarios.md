# Stage 3 — Gherkin Scenarios
## Subtopic 1.4: HD Wallets (SEP-5)

IDs carry forward from Stages 1–2.

---

## US-01: Generate a 24-word mnemonic

```gherkin
Scenario SC-01.1: generate24WordsMnemonic returns a non-empty 24-word string
  Given the SDK is available
  When the developer calls await Wallet.generate24WordsMnemonic()
  Then the returned value is a non-empty string
  And splitting it on spaces yields exactly 24 tokens
```

```gherkin
Scenario SC-01.2: Successive mnemonic generations produce unique strings
  Given the SDK is available
  When the developer calls Wallet.generate24WordsMnemonic() twice
  Then the two returned strings are different
  # (Random generation is implied — identical outputs would indicate a broken RNG)
```

---

## US-02: Create wallet and derive keypairs

```gherkin
Scenario SC-02.1: Wallet.from() returns a non-null Wallet
  Given a valid 24-word mnemonic
  When the developer calls await Wallet.from(mnemonic)
  Then a non-null Wallet object is returned
```

```gherkin
Scenario SC-02.2: getKeyPair() returns a non-null KeyPair with a G-prefixed accountId
  Given a Wallet created from a valid mnemonic
  When the developer calls await wallet.getKeyPair(index: 0)
  Then a non-null KeyPair is returned
  And the KeyPair's accountId starts with 'G'
```

```gherkin
Scenario SC-02.3: Different indices derive different accounts
  Given a Wallet created from a valid mnemonic
  When the developer derives keypairs at index 0 and index 1
  Then the two accountIds are different
  # (m/44'/148'/0' ≠ m/44'/148'/1')
```

```gherkin
Scenario SC-02.4: Same mnemonic always produces the same accountId at the same index
  Given a valid mnemonic
  And two independent Wallet objects created from that same mnemonic
  When the developer derives the keypair at index 0 from each wallet
  Then both accountIds are identical
  # (Doc: "the same phrase always produces the same accounts")
```

```gherkin
Scenario SC-02.5: Derived keypair has signing capability
  Given a Wallet created from a valid mnemonic
  When the developer derives the keypair at index 0
  Then kp.canSign() returns true
```

---

## US-03: Wallet with passphrase

```gherkin
Scenario SC-03.1: Same mnemonic with passphrase yields different accountId than without
  Given a valid mnemonic
  When one wallet is created with that mnemonic and a passphrase
  And another wallet is created with the same mnemonic but no passphrase
  And the developer derives the keypair at index 0 from each
  Then the two accountIds are different
  # (Doc: "the same mnemonic produces completely different accounts")
```

```gherkin
Scenario SC-03.2: Same mnemonic + same passphrase always yields the same accountId
  Given a valid mnemonic and a passphrase
  And two independent Wallet objects created from that mnemonic + passphrase
  When the developer derives the keypair at index 0 from each wallet
  Then both accountIds are identical
  # (BIP-39 determinism holds with passphrase too)
```
