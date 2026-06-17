# Stage 3 — Gherkin Scenarios
## Subtopic 1.2: Loading an Account

IDs carry forward from Stages 1–2.

---

## US-01: Load a Stellar account from the network

```gherkin
Scenario SC-01.1: Load a funded account returns a non-null AccountResponse
  Given a Stellar account funded on testnet via FriendBot
  And the SDK is configured for testnet
  When the developer calls sdk.accounts.account with that account's ID
  Then the call completes without throwing
  And the returned AccountResponse is not null
```

```gherkin
Scenario SC-01.2: Loaded account exposes a non-null sequence number
  Given a funded testnet account
  When the developer loads the account via sdk.accounts.account
  Then account.sequenceNumber is not null
```

```gherkin
Scenario SC-01.3: Sequence number is a valid integer
  Given a funded testnet account has been loaded
  When account.sequenceNumber is converted to a string representation
  Then that representation parses successfully as an integer
  And the parsed value is non-negative
  # (Derived from AC-01.4: "required when building transactions" → must be integer-parseable)
```

---

## US-02: Inspect account balances

```gherkin
Scenario SC-02.1: Balances list is non-empty for a funded account
  Given a funded testnet account
  When the developer accesses account.balances
  Then the list is not empty
```

```gherkin
Scenario SC-02.2: At least one balance has assetType == Asset.TYPE_NATIVE
  Given a funded testnet account
  When the developer iterates account.balances and checks assetType
  Then at least one balance entry satisfies assetType == Asset.TYPE_NATIVE
```

```gherkin
Scenario SC-02.3: Native XLM balance is greater than zero
  Given a funded testnet account
  When the developer finds the balance where assetType == Asset.TYPE_NATIVE
  Then balance.balance parses as a positive double
```

```gherkin
Scenario SC-02.4: Every balance entry exposes assetType and balance without throwing
  Given a funded testnet account
  When the developer reads balance.assetType and balance.balance on each entry
  Then no exception is thrown for any entry
  And both properties are non-null for each entry
  # (AMB-1: assetCode on non-native balances cannot be triggered without a trustline)
```

---

## US-03: Check account existence via try/catch

```gherkin
Scenario SC-03.1: Loading a non-existent account throws ErrorResponse
  Given a never-funded account ID (randomly generated)
  When the developer calls sdk.accounts.account with that ID
  Then an ErrorResponse is thrown
```

```gherkin
Scenario SC-03.2: Thrown ErrorResponse for non-existent account has code 404
  Given a never-funded account ID
  When the developer calls sdk.accounts.account and catches the thrown ErrorResponse
  Then ErrorResponse.code equals 404
```

```gherkin
Scenario Outline SC-03.3: Documented try/catch existence pattern — non-existent account
  Given exists is initialised to true
  And the account ID does not exist on testnet
  When the developer runs:
    try { await sdk.accounts.account(id); }
    on ErrorResponse catch (e) { if (e.code == 404) exists = false; }
  Then exists is false after the block
```

```gherkin
Scenario SC-03.4: Documented try/catch existence pattern — existing account
  Given exists is initialised to true
  And the account ID belongs to a funded testnet account
  When the developer runs the same try/catch existence-check pattern
  Then exists remains true after the block
  # (No ErrorResponse thrown → catch block never executes)
```
