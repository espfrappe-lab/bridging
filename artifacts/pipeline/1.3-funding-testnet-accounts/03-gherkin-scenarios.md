# Stage 3 — Gherkin Scenarios
## Subtopic 1.3: Funding Testnet Accounts

IDs carry forward from Stages 1–2.

---

## US-01: Fund a testnet account via FriendBot

```gherkin
Scenario SC-01.1: FriendBot.fundTestAccount() completes without throwing
  Given a freshly generated Stellar keypair that has never been funded
  And the SDK is available for testnet
  When the developer calls await FriendBot.fundTestAccount(keyPair.accountId)
  Then the call resolves without throwing any exception
```

```gherkin
Scenario SC-01.2: Funded account is loadable on testnet after FriendBot call
  Given FriendBot.fundTestAccount() has completed successfully for an account
  When the developer loads the account from testnet via sdk.accounts.account()
  Then a non-null AccountResponse is returned
  And the account is accessible on the testnet network
```

```gherkin
Scenario SC-01.3: Funded account holds approximately 10,000 native XLM
  Given an account funded via FriendBot on testnet
  When the developer reads the account's native XLM balance
  Then the native balance is approximately 10,000 XLM
  # (Documentation states: "funds new accounts with 10,000 test XLM")
  # (AMB-2: tolerance ±100 XLM applied for minimum reserve deductions)
```

```gherkin
Scenario SC-TL-1: FriendBot funds testnet only — account does not appear on mainnet
  Given a fresh random Stellar keypair is generated
  When FriendBot.fundTestAccount(kp.accountId) is awaited
  Then StellarSDK.TESTNET.accounts.account(kp.accountId) returns a non-null AccountResponse
  And StellarSDK.PUBLIC.accounts.account(kp.accountId) throws an error (account not found on mainnet)
  # Safety: mainnet call is a read-only HTTP GET against public Horizon — no XLM spent
```
