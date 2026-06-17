# Stage 1 — User Stories
## Subtopic 1.4: HD Wallets (SEP-5)
**Source:** `documentation/sdk-usage.md` § "HD Wallets (SEP-5)"

---

**US-01:** As a developer, I want to generate a new 24-word BIP-39 mnemonic phrase
using `Wallet.generate24WordsMnemonic()` so that I have a secure, randomly-generated
seed from which to create an HD wallet.

**US-02:** As a developer, I want to create an HD wallet from an existing mnemonic
phrase using `Wallet.from()` and derive Stellar keypairs at specific indices using
`wallet.getKeyPair(index: n)` so that I can access multiple independent accounts from
a single mnemonic, following the `m/44'/148'/{index}'` derivation path.

**US-03:** As a developer, I want to create an HD wallet with an optional BIP-39
passphrase using `Wallet.from(mnemonic, passphrase: "...")` so that the same mnemonic
produces completely different accounts when the passphrase is included, giving me a
second-factor security layer that requires both the mnemonic and the passphrase to
derive the correct accounts.

---

> **Note on doc example mnemonic:** The documentation shows `"cable spray genius state
> float ..."` as an example input to `Wallet.from()`. This is a placeholder truncated
> with "…" and cannot be used as test data. All tests generate real mnemonics
> dynamically via `Wallet.generate24WordsMnemonic()`. Flagged as AMB-1.
