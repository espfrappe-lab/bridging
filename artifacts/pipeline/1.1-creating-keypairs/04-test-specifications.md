# Stage 4 — Test Specifications
## Subtopic 1.1: Creating Keypairs
**Source:** Stage 3 Gherkin scenarios + `documentation/sdk-usage.md` § "Creating Keypairs"

---

## TS-01.1 — Random keypair returns a non-null object

| Field | Detail |
|-------|--------|
| **Maps to** | SC-01.1 / AC-01.1 |
| **Objective** | Verify that `KeyPair.random()` produces a non-null result. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | None (output is random). |
| **Execution steps** | 1. Call `KeyPair.random()` and capture the result. |
| **Expected outcomes** | The returned value is a non-null `KeyPair` instance. |
| **Assertions** | `expect(result, isNotNull)` |
| **Postconditions** | None. |

---

## TS-01.2 — Random keypair public key starts with G

| Field | Detail |
|-------|--------|
| **Maps to** | SC-01.2 / AC-01.2 |
| **Objective** | Verify that the `accountId` of a randomly-generated keypair follows the Stellar public-key format (G-prefix). |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | None (output is random). |
| **Execution steps** | 1. Call `KeyPair.random()`. 2. Read the `accountId` property. |
| **Expected outcomes** | `accountId` is a non-empty string whose first character is `G`. |
| **Assertions** | `expect(keyPair.accountId, isNotEmpty)` · `expect(keyPair.accountId.startsWith('G'), isTrue)` |
| **Oracles** | Stellar strkey format: account IDs always start with `G` (ACCOUNT_ID version byte). |
| **Postconditions** | None. |

---

## TS-01.3 — Random keypair secret seed starts with S

| Field | Detail |
|-------|--------|
| **Maps to** | SC-01.3 / AC-01.3 |
| **Objective** | Verify that the `secretSeed` of a randomly-generated keypair follows the Stellar seed format (S-prefix). |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | None (output is random). |
| **Execution steps** | 1. Call `KeyPair.random()`. 2. Read the `secretSeed` property. |
| **Expected outcomes** | `secretSeed` is a non-empty string whose first character is `S`. |
| **Assertions** | `expect(keyPair.secretSeed, isNotEmpty)` · `expect(keyPair.secretSeed.startsWith('S'), isTrue)` |
| **Oracles** | Stellar strkey format: secret seeds always start with `S` (SEED version byte). |
| **Postconditions** | None. |

---

## TS-01.4 — Random keypairs are unique

| Field | Detail |
|-------|--------|
| **Maps to** | SC-01.4 / AC-01.4 |
| **Objective** | Verify that successive calls to `KeyPair.random()` produce distinct keypairs. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | Two independent calls with no arguments. |
| **Execution steps** | 1. Call `KeyPair.random()` → `kp1`. 2. Call `KeyPair.random()` → `kp2`. |
| **Expected outcomes** | `kp1.accountId != kp2.accountId` and `kp1.secretSeed != kp2.secretSeed`. |
| **Assertions** | `expect(kp1.accountId, isNot(equals(kp2.accountId)))` · `expect(kp1.secretSeed, isNot(equals(kp2.secretSeed)))` |
| **Oracles** | Ed25519 key generation uses a cryptographically-secure RNG; collision probability is negligible. |
| **Postconditions** | None. |

---

## TS-01.5 — Random keypair is signing-capable

| Field | Detail |
|-------|--------|
| **Maps to** | SC-01.5 / AC-01.5 |
| **Objective** | Verify that a randomly-generated keypair holds a private key and therefore `canSign()` returns `true`. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | None. |
| **Execution steps** | 1. Call `KeyPair.random()`. 2. Call `canSign()` on the result. |
| **Expected outcomes** | `canSign()` returns `true`. |
| **Assertions** | `expect(keyPair.canSign(), isTrue)` |
| **Postconditions** | None. |

---

## TS-02.1 — Valid secret seed returns a non-null KeyPair

| Field | Detail |
|-------|--------|
| **Maps to** | SC-02.1 / AC-02.1 |
| **Objective** | Verify that `KeyPair.fromSecretSeed()` succeeds on a valid input. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | `seed = "SCZANGBA5YHTNYVVV3C7CAZMTQDBJHJG6C34JFD6XVEAEPTBED53FETV"` (example from documentation). |
| **Execution steps** | 1. Call `KeyPair.fromSecretSeed(seed)`. |
| **Expected outcomes** | A non-null `KeyPair` object is returned without throwing. |
| **Assertions** | `expect(result, isNotNull)` |
| **Postconditions** | None. |

---

## TS-02.2 — Secret seed round-trip consistency

| Field | Detail |
|-------|--------|
| **Maps to** | SC-02.2 / AC-02.2 |
| **Objective** | Verify that reading `secretSeed` from a keypair created via `fromSecretSeed(seed)` returns the exact original seed string. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | `seed = "SCZANGBA5YHTNYVVV3C7CAZMTQDBJHJG6C34JFD6XVEAEPTBED53FETV"` |
| **Execution steps** | 1. Call `KeyPair.fromSecretSeed(seed)` → `kp`. 2. Read `kp.secretSeed`. |
| **Expected outcomes** | `kp.secretSeed == seed`. |
| **Assertions** | `expect(kp.secretSeed, equals(seed))` |
| **Oracles** | The seed is an encoded representation of the raw private key bytes; encoding must round-trip losslessly. |
| **Postconditions** | None. |

---

## TS-02.3 — Keypair derivation from seed is deterministic

| Field | Detail |
|-------|--------|
| **Maps to** | SC-02.3 / AC-02.3 |
| **Objective** | Verify that the same secret seed always produces the same `accountId`. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | Known seed/accountId pair: `seed = "SDJHRQF4GCMIIKAAAQ6IHY42X73FQFLHUULAPSKKD4DFDM7UXWWCRHBE"`, `expectedAccountId = "GCZHXL5HXQX5ABDM26LHYRCQZ5OJFHLOPLZX47WEBP3V2PF5AVFK2A5D"`. (Note: AMB-3 — the docs' example seed has no documented expected account ID; this known-good pair is used instead.) |
| **Execution steps** | 1. Call `KeyPair.fromSecretSeed(seed)` → `kp1`. 2. Call `KeyPair.fromSecretSeed(seed)` again → `kp2`. 3. Compare both results against each other and against `expectedAccountId`. |
| **Expected outcomes** | Both calls produce the same `accountId` equal to `expectedAccountId`. |
| **Assertions** | `expect(kp1.accountId, equals(expectedAccountId))` · `expect(kp2.accountId, equals(kp1.accountId))` |
| **Oracles** | Ed25519 public key derivation is deterministic: the same seed bytes always yield the same public key bytes, and strkey encoding is also deterministic. |
| **Postconditions** | None. |

---

## TS-02.4 — Keypair from seed can sign

| Field | Detail |
|-------|--------|
| **Maps to** | SC-02.4 / AC-02.4 |
| **Objective** | Verify that a keypair restored from a secret seed holds the private key and can sign. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | `seed = "SCZANGBA5YHTNYVVV3C7CAZMTQDBJHJG6C34JFD6XVEAEPTBED53FETV"` |
| **Execution steps** | 1. Call `KeyPair.fromSecretSeed(seed)`. 2. Call `canSign()` on the result. |
| **Expected outcomes** | `canSign()` returns `true`. |
| **Assertions** | `expect(kp.canSign(), isTrue)` |
| **Postconditions** | None. |

---

## TS-02.5 — Invalid secret seed throws FormatException

| Field | Detail |
|-------|--------|
| **Maps to** | SC-02.5 / AC-02.5 |
| **Objective** | Verify that `fromSecretSeed()` rejects invalid input with a `FormatException`. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | (a) `"INVALID_SEED"` — arbitrary non-strkey string. (b) `"GBBM6BKZPEHWYO3E3YKREDPQXMS4VK35YLNU7NFBRI26RAN7GI5POFBB"` — a valid account ID (G…) passed where a seed (S…) is expected. |
| **Execution steps** | For each invalid input: call `KeyPair.fromSecretSeed(input)` inside an `expect(() => …, throwsA(…))` block. |
| **Expected outcomes** | A `FormatException` is thrown for each invalid input. |
| **Assertions** | `expect(() => KeyPair.fromSecretSeed(input), throwsA(isA<FormatException>()))` |
| **Oracles** | AMB-1: `StrKey.decodeStellarSecretSeed()` throws `FormatException` on invalid/mismatched version bytes. |
| **Postconditions** | None. |

---

## TS-03.1 — Valid account ID returns a non-null KeyPair

| Field | Detail |
|-------|--------|
| **Maps to** | SC-03.1 / AC-03.1 |
| **Objective** | Verify that `KeyPair.fromAccountId()` succeeds on a valid account ID. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | `accountId = "GBBM6BKZPEHWYO3E3YKREDPQXMS4VK35YLNU7NFBRI26RAN7GI5POFBB"` |
| **Execution steps** | 1. Call `KeyPair.fromAccountId(accountId)`. |
| **Expected outcomes** | A non-null `KeyPair` object is returned without throwing. |
| **Assertions** | `expect(result, isNotNull)` |
| **Postconditions** | None. |

---

## TS-03.2 — Public-key-only keypair preserves the account ID

| Field | Detail |
|-------|--------|
| **Maps to** | SC-03.2 / AC-03.2 |
| **Objective** | Verify that the `accountId` property of the returned keypair equals the input string. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | `accountId = "GBBM6BKZPEHWYO3E3YKREDPQXMS4VK35YLNU7NFBRI26RAN7GI5POFBB"` |
| **Execution steps** | 1. Call `KeyPair.fromAccountId(accountId)` → `kp`. 2. Read `kp.accountId`. |
| **Expected outcomes** | `kp.accountId == accountId`. |
| **Assertions** | `expect(kp.accountId, equals(accountId))` |
| **Postconditions** | None. |

---

## TS-03.3 — Public-key-only keypair cannot sign

| Field | Detail |
|-------|--------|
| **Maps to** | SC-03.3 / AC-03.3 |
| **Objective** | Verify that `canSign()` returns `false` for a keypair created without a private key. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | `accountId = "GBBM6BKZPEHWYO3E3YKREDPQXMS4VK35YLNU7NFBRI26RAN7GI5POFBB"` |
| **Execution steps** | 1. Call `KeyPair.fromAccountId(accountId)` → `kp`. 2. Call `kp.canSign()`. |
| **Expected outcomes** | `canSign()` returns `false`. |
| **Assertions** | `expect(kp.canSign(), isFalse)` |
| **Oracles** | The docs state "cannot sign" for public-key-only keypairs; `canSign()` is the authoritative API for this capability check. |
| **Postconditions** | None. |

---

## TS-03.4 — Invalid account ID throws FormatException

| Field | Detail |
|-------|--------|
| **Maps to** | SC-03.4 / AC-03.4 |
| **Objective** | Verify that `fromAccountId()` rejects invalid input with a `FormatException`. |
| **Preconditions** | The `stellar_flutter_sdk` package is imported. |
| **Test data** | (a) `"INVALID_ACCOUNT_ID"` — arbitrary non-strkey string. (b) `"SCZANGBA5YHTNYVVV3C7CAZMTQDBJHJG6C34JFD6XVEAEPTBED53FETV"` — a valid secret seed (S…) passed where an account ID (G…) is expected. |
| **Execution steps** | For each invalid input: call `KeyPair.fromAccountId(input)` inside an `expect(() => …, throwsA(…))` block. |
| **Expected outcomes** | A `FormatException` is thrown for each invalid input. |
| **Assertions** | `expect(() => KeyPair.fromAccountId(input), throwsA(isA<FormatException>()))` |
| **Oracles** | AMB-1: `StrKey.decodeStellarAccountId()` throws `FormatException` on invalid/mismatched version bytes. |
| **Postconditions** | None. |
