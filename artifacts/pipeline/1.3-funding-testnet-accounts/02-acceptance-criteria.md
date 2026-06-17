# Stage 2 — Acceptance Criteria
## Subtopic 1.3: Funding Testnet Accounts
**Source:** `documentation/sdk-usage.md` § "Funding Testnet Accounts"

---

## US-01 — Fund a testnet account via FriendBot

**AC-01.1** `FriendBot.fundTestAccount(accountId)` shall be asynchronous (the call
must be `await`-able, as shown in the doc example).

**AC-01.2** A valid Stellar account ID (G-address) shall be accepted as input to
`FriendBot.fundTestAccount()`.

**AC-01.3** After a successful call, the funded account shall exist on the testnet
network and be loadable (i.e., a subsequent `sdk.accounts.account(id)` returns a
valid `AccountResponse`).

**AC-01.4** After a successful call, the funded account's native XLM balance shall
be approximately 10,000 XLM, as stated in the documentation: *"funds new accounts
with 10,000 test XLM"*.

**AC-01.5** The funded account shall be a newly created account (the documentation
states "funds new accounts", implying the target keypair had no prior on-chain
existence before the call).

---

## Ambiguities and limitations flagged

**AMB-1 — Return type not specified:** The documentation code example shows
`await FriendBot.fundTestAccount(keyPair.accountId)` without capturing a return
value. The return type (bool, void, or other) is not declared. Generated tests
therefore verify the postcondition (account funded with XLM) rather than a
return-value assertion.

**AMB-2 — "approximately 10,000":** The documentation says exactly "10,000 test XLM"
but Stellar accounts have a minimum reserve requirement that may affect the displayed
balance. The tests use `closeTo(10000, 100)` (9,900–10,100 range) to accommodate
minor network-level deductions while still asserting the documented amount.

**TL-1 — Upgraded to AC-TL-1:** Originally flagged as untestable. Revised after
confirming that `FriendBot.fundTestAccount()` uses a hardcoded testnet URL
(`https://friendbot.stellar.org`). The constraint is verifiable via a read-only
mainnet Horizon account lookup — no mainnet XLM is spent.

**AC-TL-1** FriendBot only funds accounts on testnet. After `fundTestAccount(kp.accountId)`,
the account shall exist on testnet Horizon (`StellarSDK.TESTNET`) but shall NOT
exist on mainnet Horizon (`StellarSDK.PUBLIC`).
