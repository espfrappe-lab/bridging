# Topic Index — SDK Usage Guide

Numbered index of all topics in `documentation/sdk-usage.md`.

---

## 1. Keypairs & Accounts

- **1.1** Creating Keypairs
- **1.2** Loading an Account
- **1.3** Funding Testnet Accounts
- **1.4** HD Wallets (SEP-5)
- **1.5** Muxed Accounts
- **1.6** Connecting to Networks

---

## 2. Building Transactions

- **2.1** Simple Payments
- **2.2** Multi-Operation Transactions
- **2.3** Memos, Time Bounds, and Fees
- **2.4** Fee Bump Transactions

---

## 3. Operations

### 3.1 Payment Operations

### 3.2 Path Payment Operations

### 3.3 Account Operations

- **3.3.1** Create Account
- **3.3.2** Merge Account
- **3.3.3** Manage Data
- **3.3.4** Set Options
  - **3.3.4.1** Set Home Domain
  - **3.3.4.2** Configure Multi-Sig Thresholds
  - **3.3.4.3** Add or Remove Signers
  - **3.3.4.4** Set Account Flags
- **3.3.5** Bump Sequence

### 3.4 Asset Operations

- **3.4.1** Create Trustline
- **3.4.2** Modify Trustline Limit
- **3.4.3** Remove Trustline
- **3.4.4** Authorize Trustline (Issuer Only)

### 3.5 Trading Operations

- **3.5.1** Create Sell Offer
- **3.5.2** Create Buy Offer
- **3.5.3** Update Offer
- **3.5.4** Cancel Offer
- **3.5.5** Passive Sell Offer

### 3.6 Claimable Balance Operations

- **3.6.1** Create Claimable Balance
- **3.6.2** Predicates
- **3.6.3** Claim Balance

### 3.7 Liquidity Pool Operations

- **3.7.1** Pool Share Trustline
- **3.7.2** Get Pool ID
- **3.7.3** Deposit Liquidity
- **3.7.4** Withdraw Liquidity

### 3.8 Sponsorship Operations

- **3.8.1** Sponsor Account Creation
- **3.8.2** Sponsor Trustline
- **3.8.3** Revoke Sponsorship

---

## 4. Querying Horizon Data

### 4.1 Account Queries

- **4.1.1** Get Single Account
- **4.1.2** Check if Account Exists
- **4.1.3** Query by Signer
- **4.1.4** Query by Asset
- **4.1.5** Query by Sponsor
- **4.1.6** Get Account Data Entry

### 4.2 Transaction Queries

- **4.2.1** Get Single Transaction
- **4.2.2** Transactions for Account
- **4.2.3** Include Failed Transactions
- **4.2.4** Transactions by Related Resource

### 4.3 Operation Queries

- **4.3.1** Get Single Operation
- **4.3.2** Operations for Account
- **4.3.3** Operations in Transaction
- **4.3.4** Handling Operation Types

### 4.4 Effect Queries

### 4.5 Ledger & Payment Queries

### 4.6 Offer Queries

- **4.6.1** Get Single Offer
- **4.6.2** Offers by Account
- **4.6.3** Offers by Asset
- **4.6.4** Offers by Sponsor

### 4.7 Trade Queries

- **4.7.1** Trades by Account
- **4.7.2** Trades by Asset Pair
- **4.7.3** Trades by Offer
- **4.7.4** Trade Aggregations (OHLCV)

### 4.8 Asset Queries

- **4.8.1** Find by Code
- **4.8.2** Find by Issuer

### 4.9 Order Book Queries

### 4.10 Payment Path Queries

- **4.10.1** Strict Send Paths
- **4.10.2** Strict Receive Paths

### 4.11 Claimable Balance Queries

- **4.11.1** Get Single Balance
- **4.11.2** Find by Claimant
- **4.11.3** Find by Sponsor
- **4.11.4** Find by Asset

### 4.12 Liquidity Pool Queries

- **4.12.1** Get Single Pool
- **4.12.2** Find by Reserve Assets

### 4.13 Pagination

---

## 5. Streaming (SSE)

- **5.1** Stream Payments
- **5.2** Stream Transactions
- **5.3** Stream Ledgers
- **5.4** Stream Operations
- **5.5** Stream Effects
- **5.6** Stream Trades
- **5.7** Stream Order Book
- **5.8** Stream Offers

---

## 6. Network Communication

### 6.1 Transaction Submission

- **6.1.1** Synchronous Submission
- **6.1.2** Asynchronous Submission

### 6.2 Fee Statistics

- **6.2.1** Fee Charged Statistics
- **6.2.2** Max Fee Statistics

### 6.3 Error Handling

- **6.3.1** Handling Submission Errors
- **6.3.2** Horizon HTTP Errors
- **6.3.3** Common Result Codes

### 6.4 Message Signing (SEP-53)

- **6.4.1** Sign a Message
- **6.4.2** Verify a Message
- **6.4.3** Verify with Public Key Only

---

## 7. Assets

- **7.1** Native XLM
- **7.2** Credit Assets
- **7.3** Auto-Detect Code Length
- **7.4** Canonical Form
- **7.5** Pool Share Assets
- **7.6** Trustlines
