# Stage 3 — Gherkin Scenarios: 2.2 Multi-Operation Transactions

---

```gherkin
Feature: Multi-Operation Transactions — 2.2

  Background:
    Given the Stellar SDK is configured for TESTNET
    And an issuer/funder account is funded via FriendBot
    And a fresh random keypair is generated for the new account

  # AC-01.1, AC-01.2
  Scenario SC-01.1: Build a CreateAccountOperation
    Given a valid new account G-address and a starting balance of "5"
    When CreateAccountOperationBuilder(newAccountId, "5").build() is called
    Then the result is a non-null CreateAccountOperation
    And no exception is thrown during build

  # AC-02.1, AC-02.2, AC-02.3
  Scenario SC-02.1: Build a ChangeTrustOperation with a custom source account
    Given a custom USD asset with the issuer's account as issuer
    And the new account's G-address
    When ChangeTrustOperationBuilder(usdAsset, "10000").setSourceAccount(newAccountId).build() is called
    Then the result is a non-null ChangeTrustOperation
    And the operation source is set to the new account (not the funder)
    And no exception is thrown during build

  # AC-03.1
  Scenario SC-03.1: Build a PaymentOperation for a custom asset
    Given a custom USD asset and the new account's G-address
    When PaymentOperationBuilder(newAccountId, usdAsset, "100").build() is called
    Then the result is a non-null PaymentOperation

  # AC-04.1, AC-04.2
  Scenario SC-04.1: Bundle three operations into one transaction
    Given a funder AccountResponse loaded from Horizon
    And three built operations (CreateAccount, ChangeTrust, Payment)
    When TransactionBuilder(funder).addOperation(op1).addOperation(op2).addOperation(op3).build() is called
    Then the result is a non-null Transaction
    And transaction.operations.length equals 3

  # AC-05.1, AC-05.2
  Scenario SC-05.1: Sign a transaction with two keypairs
    Given a built three-operation transaction
    When transaction.sign(funderKeyPair, Network.TESTNET) is called
    Then no exception is thrown
    When transaction.sign(newAccountKeyPair, Network.TESTNET) is called
    Then no exception is thrown
    And the transaction now carries two signatures

  # AC-06.1, AC-06.2
  Scenario SC-06.1: Submit the fully signed multi-operation transaction
    Given a three-operation transaction signed by both the funder and the new account
    When sdk.submitTransaction(transaction) is awaited
    Then response.success is true
    And all three operations executed atomically on the ledger

  # AC-06.2 (negative path — rollback)
  Scenario SC-06.2: Atomic rollback when one operation fails
    Given a funder account funded via FriendBot (~10,000 XLM)
    And a fresh newAccountKeyPair is generated
    When a two-operation transaction is submitted containing:
      Op 1: CreateAccountOperation(newAccount, "5") — would succeed in isolation
      Op 2: PaymentOperation(native XLM, amount="50000") — exceeds funder balance
    Then the transaction response indicates failure (success == false)
    And the new account does NOT exist on Horizon (CreateAccountOperation was rolled back)

  # AC-07.1, AC-07.2
  Scenario SC-07.1: Verify the new account exists after submission
    Given a successful multi-operation transaction submission
    When sdk.accounts.account(newAccountId) is awaited
    Then the returned AccountResponse is not null
    And AccountResponse.accountId equals the newAccountId used in the CreateAccountOperation
```
