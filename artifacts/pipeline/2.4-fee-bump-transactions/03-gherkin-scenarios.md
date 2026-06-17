# Stage 3 — Gherkin Scenarios: 2.4 Fee Bump Transactions

---

```gherkin
Feature: Fee Bump Transactions — 2.4

  Background:
    Given the Stellar SDK is configured for TESTNET
    And a user (sender) account is funded via FriendBot
    And a receiver account is funded via FriendBot
    And a fee payer account is funded via FriendBot

  # AC-01.1, AC-01.2, AC-02.1, AC-03.1
  Scenario SC-01.1: Build a FeeBumpTransaction wrapping a pre-signed inner transaction
    Given a user AccountResponse loaded from Horizon
    And an inner Transaction built with two PaymentOperations and signed by the user
    When FeeBumpTransactionBuilder(innerTransaction).setBaseFee(300).setFeeAccount(feePayerKeyPair.accountId).build() is called
    Then the result is a non-null FeeBumpTransaction
    And no exception is thrown during build

  # AC-02.2
  Scenario SC-02.1: Fee formula — 300 stroops meets the minimum for a 2-op inner transaction
    Given an inner transaction with 2 operations at the default base fee of 100 stroops each
    Then the documented minimum base fee = (100 * 2) + 100 = 300 stroops
    And setting baseFee(300) on the FeeBumpTransactionBuilder satisfies this constraint

  # AC-04.1, AC-04.2
  Scenario SC-04.1: Fee payer signs the fee bump; user signed the inner transaction
    Given a built FeeBumpTransaction
    When feeBumpTx.sign(feePayerKeyPair, Network.TESTNET) is called
    Then no exception is thrown
    And the fee bump carries the fee payer's signature
    And the inner transaction was already signed only by the user (not the fee payer)

  # AC-05.1, AC-05.2
  Scenario SC-05.1: Submit fee bump and receive success
    Given a FeeBumpTransaction signed by the fee payer wrapping a user-signed inner transaction
    When sdk.submitFeeBumpTransaction(feeBumpTx) is awaited
    Then response.success is true
```
