# Stage 4 — Test Specifications
## Subtopic 1.4: HD Wallets (SEP-5)

Language-agnostic blueprints. IDs carry forward from Stages 1–3.
All operations are purely local (no network); no FriendBot or testnet connectivity required.

---

## Group US-01: Wallet.generate24WordsMnemonic()

### TS-01.1 — Returns a non-empty 24-word string
| Field | Detail |
|---|---|
| **Scenario** | SC-01.1 |
| **Criteria** | AC-01.1, AC-01.2, AC-01.3 |
| **Objective** | Prove the method returns a valid BIP-39 mnemonic phrase of exactly 24 words |
| **Test data** | None (no input) |
| **Steps** | 1. Call `await Wallet.generate24WordsMnemonic()` 2. Split result on `' '` |
| **Assertions** | `result` is not empty; `result.split(' ').length == 24` |
| **Test oracle** | 24 words is the documented count; any deviation indicates the wrong variant or a broken generator |

---

### TS-01.2 — Successive calls produce different mnemonics
| Field | Detail |
|---|---|
| **Scenario** | SC-01.2 |
| **Criteria** | AC-01.4 |
| **Objective** | Prove mnemonic generation is random, not fixed |
| **Steps** | 1. Call `generate24WordsMnemonic()` twice 2. Compare results |
| **Assertions** | `m1 != m2` |
| **Test oracle** | Probabilistic uniqueness: identical outputs from independent calls would indicate a broken RNG or constant seed. Collision probability is negligible (2¹²⁸ entropy). |

---

## Group US-02: Wallet.from() + getKeyPair()

*Setup: `setUpAll` generates one mnemonic and builds one `Wallet` to share across TS-02.1 through TS-02.6.*

### TS-02.1 — Wallet.from() returns a non-null Wallet
| Field | Detail |
|---|---|
| **Scenario** | SC-02.1 |
| **Criteria** | AC-02.1 |
| **Objective** | Prove `Wallet.from()` successfully constructs a `Wallet` from a valid mnemonic |
| **Test data** | Mnemonic from `setUpAll` |
| **Steps** | 1. Assert `_wallet` (built in `setUpAll`) is not null |
| **Assertions** | `expect(_wallet, isNotNull)` |

---

### TS-02.2 — getKeyPair(index: 0) returns a non-null KeyPair with G-prefixed accountId
| Field | Detail |
|---|---|
| **Scenario** | SC-02.2 |
| **Criteria** | AC-02.2, AC-02.3 |
| **Objective** | Prove derivation succeeds and produces a valid Stellar address |
| **Steps** | 1. Call `await _wallet.getKeyPair(index: 0)` 2. Check result |
| **Assertions** | `kp` is not null; `kp.accountId.startsWith('G')` |
| **Test oracle** | A 'G' prefix guarantees the Stellar StrKey encoding is valid for a public key |

---

### TS-02.3 — Keypairs at different indices have different accountIds
| Field | Detail |
|---|---|
| **Scenario** | SC-02.3 |
| **Criteria** | AC-02.4 |
| **Objective** | Prove each HD index produces a distinct account (correct path increment `m/44'/148'/{index}'`) |
| **Steps** | 1. Derive at index 0 and index 1 from `_wallet` 2. Compare accountIds |
| **Assertions** | `kp0.accountId != kp1.accountId` |
| **Test oracle** | If index 0 and index 1 produce the same account, the derivation path is broken |

---

### TS-02.4 — Same mnemonic always produces the same accountId at index 0 (determinism)
| Field | Detail |
|---|---|
| **Scenario** | SC-02.4 |
| **Criteria** | AC-02.5 |
| **Objective** | Verify the documentation's core promise: *"the same phrase always produces the same accounts"* |
| **Steps** | 1. Build `wallet2 = await Wallet.from(_mnemonic)` (independent of `_wallet`) 2. Derive at index 0 from both 3. Compare |
| **Assertions** | `kp0.accountId == kp0Again.accountId` |
| **Test oracle** | Core BIP-39 / SLIP-0010 invariant: deterministic derivation. A mismatch here means the wallet implementation is non-deterministic. |

---

### TS-02.5 — Derived keypair can sign
| Field | Detail |
|---|---|
| **Scenario** | SC-02.5 |
| **Criteria** | AC-02.6 |
| **Objective** | Prove HD derivation includes the private key (required for transaction signing) |
| **Steps** | 1. Derive keypair at index 0 2. Call `kp.canSign()` |
| **Assertions** | `expect(kp.canSign(), isTrue)` |
| **Test oracle** | HD wallets always yield full keypairs (public + private); `canSign() == false` would mean the private key was stripped |

---

## Group US-03: Wallet.from() with passphrase

*Setup: `setUpAll` generates one shared mnemonic.*

### TS-03.1 — Passphrase produces different accountId than no passphrase (same mnemonic)
| Field | Detail |
|---|---|
| **Scenario** | SC-03.1 |
| **Criteria** | AC-03.1, AC-03.2 |
| **Objective** | Verify the passphrase acts as a true second factor, altering the derived accounts |
| **Test data** | Shared `_mnemonic`; passphrase `'my-secret-passphrase'` |
| **Steps** | 1. `walletWith = await Wallet.from(_mnemonic, passphrase: 'my-secret-passphrase')` 2. `walletNo = await Wallet.from(_mnemonic)` 3. Derive index 0 from each 4. Compare |
| **Assertions** | `kpWith.accountId != kpNo.accountId` |
| **Test oracle** | Doc: *"the same mnemonic produces completely different accounts"* — a match would mean the passphrase parameter is being ignored |

---

### TS-03.2 — Same mnemonic + same passphrase is deterministic
| Field | Detail |
|---|---|
| **Scenario** | SC-03.2 |
| **Criteria** | AC-03.3 |
| **Objective** | Prove that passphrase derivation is also deterministic (same inputs always → same outputs) |
| **Test data** | Shared `_mnemonic`; passphrase `'my-secret-passphrase'` |
| **Steps** | 1. Build two independent wallets with same mnemonic + passphrase 2. Derive index 0 from each 3. Compare |
| **Assertions** | `kp1.accountId == kp2.accountId` |
| **Test oracle** | BIP-39 determinism must hold with passphrase; a mismatch means the passphrase introduces non-determinism (a correctness bug) |
