# Stage 3 — Gherkin Scenarios: 2.3 Memos, Time Bounds, and Fees

---

```gherkin
Feature: Memos, Time Bounds, and Fees — 2.3

  Background:
    Given the Stellar SDK is configured for TESTNET
    And a sender account and a receiver account are funded via FriendBot

  # AC-01.1
  Scenario SC-01.1: Build a text memo
    Given the memo text "Payment for invoice #1234"
    When Memo.text("Payment for invoice #1234") is called
    Then the result is a non-null MemoText object

  # AC-01.2, AC-01.3, AC-02.1–AC-02.5
  Scenario SC-02.1: Submit a transaction with a text memo and verify on-chain persistence
    Given a sender AccountResponse loaded from Horizon
    And a PaymentOperation targeting the receiver for "1" XLM
    When a Transaction is built with addMemo(Memo.text("Payment for invoice #1234"))
    And the transaction is signed with the sender keypair on TESTNET
    And sdk.submitTransaction(transaction) is awaited
    Then response.success is true
    And response.hash is not null
    When sdk.transactions.transaction(response.hash!) is awaited
    Then the returned TransactionResponse is not null
    And txResponse.memo is not null
    And txResponse.memo is of type MemoText
    And (txResponse.memo as MemoText).text equals "Payment for invoice #1234"

  # AC-03.1
  Scenario SC-03.1: Build a numeric id memo
    Given a numeric memo value of 12345
    When Memo.id(12345) is called
    Then the result is a non-null Memo object

  # AC-03.2, AC-03.3
  Scenario SC-03.2: Build hash and returnHash memos from 32 bytes
    Given a 32-byte Uint8List of zeros
    When Memo.hash(bytes) is called
    Then the result is a non-null Memo object
    When Memo.returnHash(bytes) is called
    Then the result is a non-null Memo object

  # AC-04.1, AC-04.2
  Scenario SC-04.1: Attach time bounds to a transaction builder without error
    Given the current Unix timestamp in seconds as `now`
    And a TimeBounds constructed with minTime = now - 60 and maxTime = now + 300
    When TransactionBuilder(account).addOperation(op).addTimeBounds(timeBounds).build() is called
    Then no exception is thrown
    And the resulting Transaction is not null

  # AC-04.3
  Scenario SC-04.2: Submit a transaction with a valid time window
    Given a transaction built with TimeBounds(now - 60, now + 300)
    When the transaction is signed and submitted
    Then response.success is true

  # AC-05.1
  Scenario SC-05.1: Apply a custom fee to a transaction builder without error
    Given a loaded sender AccountResponse
    When TransactionBuilder(account).addOperation(op).setMaxOperationFee(200).build() is called
    Then no exception is thrown
    And the resulting Transaction is not null

  # AC-05.2
  Scenario SC-05.2: Submit a transaction with a custom 200-stroop fee
    Given a transaction built with setMaxOperationFee(200)
    When the transaction is signed and submitted
    Then response.success is true
```
