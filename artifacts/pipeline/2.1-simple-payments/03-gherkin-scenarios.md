# Stage 3 — Gherkin Scenarios: 2.1 Simple Payments

---

```gherkin
Feature: Simple Payments — 2.1

  Background:
    Given the Stellar SDK is configured for TESTNET
    And a sender account and a receiver account are both funded via FriendBot

  # AC-01.1, AC-01.2, AC-01.3
  Scenario SC-01.1: Build a native XLM payment operation
    Given a valid receiver G-address, Asset.NATIVE, and the amount "100.50"
    When PaymentOperationBuilder(destination, Asset.NATIVE, "100.50").build() is called
    Then the result is a non-null PaymentOperation
    And the result is an instance of PaymentOperation

  # AC-02.1, AC-02.2
  Scenario SC-02.1: Wrap a payment operation in a transaction
    Given a loaded AccountResponse for the sender
    And a built PaymentOperation
    When TransactionBuilder(senderAccount).addOperation(paymentOp).build() is called
    Then the result is a non-null Transaction
    And transaction.operations.length equals 1

  # AC-03.1
  Scenario SC-03.1: Sign a transaction with the correct network passphrase
    Given a built unsigned Transaction
    And the sender KeyPair
    When transaction.sign(senderKeyPair, Network.TESTNET) is called
    Then no exception is thrown

  # AC-04.1, AC-04.2, AC-04.3
  Scenario SC-04.1: Submit a signed XLM payment and receive confirmation
    Given a Transaction signed with the sender keypair and Network.TESTNET
    When sdk.submitTransaction(transaction) is awaited
    Then response.success is true
    And response.hash is not null
    And response.hash is not empty

  # AC-05.1, AC-05.2
  Scenario SC-05.1: Recipient balance increases after a successful payment
    Given Alice and Bob are both funded with FriendBot (approximately 10 000 XLM each)
    And Alice sends 100 XLM to Bob via a signed, submitted transaction
    When Bob's AccountResponse is loaded from Horizon after the payment
    Then bobAccount is not null
    And Bob's native XLM balance is at least 10 100.0 XLM

  # AC-06.1, AC-06.2
  Scenario SC-06.1: Payment with a text memo submits successfully
    Given a built PaymentOperation for a native XLM transfer
    When TransactionBuilder(senderAccount).addOperation(op).addMemo(Memo.text("Coffee payment")).build() is called
    And the transaction is signed and submitted
    Then response.success is true
    And response.hash is not null
```
