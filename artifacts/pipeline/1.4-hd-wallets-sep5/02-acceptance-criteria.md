# Stage 2 — Acceptance Criteria
## Subtopic 1.4: HD Wallets (SEP-5)
**Source:** `documentation/sdk-usage.md` § "HD Wallets (SEP-5)"

---

## US-01 — Generate a 24-word mnemonic

**AC-01.1** `Wallet.generate24WordsMnemonic()` shall be asynchronous (await-able).

**AC-01.2** The returned value shall be a non-empty string.

**AC-01.3** The returned string shall consist of exactly 24 space-separated words,
as stated by the method name and the documentation comment: *"Generate 24-word
mnemonic"*.

**AC-01.4** Two successive calls to `Wallet.generate24WordsMnemonic()` shall produce
different mnemonic strings (probabilistic uniqueness — the documentation implies
random generation).

---

## US-02 — Create wallet and derive keypairs

**AC-02.1** `Wallet.from(mnemonic)` shall be asynchronous and return a non-null
`Wallet` object.

**AC-02.2** `wallet.getKeyPair(index: n)` shall be asynchronous and return a non-null
`KeyPair`.

**AC-02.3** The `accountId` of any derived `KeyPair` shall start with `'G'` (valid
Stellar StrKey-encoded public key).

**AC-02.4** Keypairs derived at different indices from the same wallet shall have
different `accountId` values. The documentation shows `account0` and `account1` as
distinct, and states accounts are derived at `m/44'/148'/{index}'`.

**AC-02.5** The same mnemonic shall always produce the same `accountId` at the same
index (determinism). The documentation states: *"the same phrase always produces the
same accounts"*.

**AC-02.6** Each derived `KeyPair` shall be capable of signing (`canSign()` returns
`true`), because HD derivation includes the private key at every index.

---

## US-03 — Wallet with passphrase

**AC-03.1** `Wallet.from(mnemonic, passphrase: "...")` shall be asynchronous and
return a non-null `Wallet`.

**AC-03.2** A wallet created with a passphrase shall derive a different `accountId`
at the same index compared to a wallet created from the identical mnemonic without a
passphrase. The documentation states: *"the same mnemonic produces completely different
accounts"*.

**AC-03.3** The same mnemonic combined with the same passphrase shall always produce
the same `accountId` at the same index (determinism with passphrase) — implied by
*"the same phrase always produces the same accounts"* and BIP-39 determinism.

---

## Ambiguities and limitations flagged

**AMB-1 — Placeholder mnemonic in docs:** `"cable spray genius state float ..."` is
truncated in the documentation and cannot be used as test input. Tests generate
mnemonics dynamically via `Wallet.generate24WordsMnemonic()`.

**AMB-2 — Index constraints:** The docs show indices 0 and 1 in code examples and
mention the path `m/44'/148'/{index}'` but do not specify whether index is bounded
or must be non-negative. Tests use only the documented values (0 and 1).

**AMB-3 — BIP-39 / SLIP-0010 standard compliance:** The documentation claims
compliance with BIP-39 and SLIP-0010 but provides no test vectors for cross-library
or cross-SDK verification. The determinism test (AC-02.5) is the closest testable
proxy for standards compliance.

**AMB-4 — Informational note not testable:** *"Keep both the mnemonic AND the
passphrase safe"* is a security advisory, not an API behavior. No test generated.
