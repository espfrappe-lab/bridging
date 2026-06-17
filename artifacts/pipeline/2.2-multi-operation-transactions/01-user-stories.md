# Stage 1 — User Stories: 2.2 Multi-Operation Transactions

Source: `documentation/sdk-usage.md` §Multi-Operation Transactions

---

**US-01:** As a developer, I want to build a `CreateAccountOperation` that creates a new Stellar account with a starting XLM balance, so that the account exists on the network and can receive assets.

**US-02:** As a developer, I want to build a `ChangeTrustOperation` that sets the source account to the newly created account, so that the new account establishes a trustline for a custom asset within the same atomic transaction.

**US-03:** As a developer, I want to build a `PaymentOperation` that sends a custom asset to the newly created account, so that the account is immediately funded with the asset after the transaction completes.

**US-04:** As a developer, I want to bundle all three operations into a single transaction using chained `addOperation()` calls, so that they execute atomically — either all succeed or all are rolled back.

**US-05:** As a developer, I want to sign the multi-operation transaction with both the funder's keypair and the new account's keypair, so that the network can verify authorization for all operation sources in the transaction.

**US-06:** As a developer, I want the entire transaction to be atomic — if any one operation fails, the whole transaction is rolled back, so that the ledger never enters a partial state.

**US-07:** As a developer, I want to verify that the new account exists on Horizon after a successful multi-operation transaction, so that I can confirm account creation completed as expected.
