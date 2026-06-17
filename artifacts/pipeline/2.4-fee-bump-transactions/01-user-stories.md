# Stage 1 — User Stories: 2.4 Fee Bump Transactions

Source: `documentation/sdk-usage.md` § Fee Bump Transactions (section 2.4)

---

## US-01 — Wrap an inner transaction in a fee bump

As a service developer, I want to wrap an already-signed inner `Transaction` in a `FeeBumpTransactionBuilder`, so that a different account can pay the fee instead of the original sender.

## US-02 — Set a valid base fee on the fee bump

As a service developer, I want to set the base fee on a fee bump transaction using `.setBaseFee(stroops)`, so that the fee satisfies the protocol minimum: `(inner_base_fee × inner_ops) + 100`.

## US-03 — Designate the fee payer account

As a service developer, I want to call `.setFeeAccount(accountId)` to name the account that will cover the fee, so that fees are deducted from the fee payer's balance rather than the original sender's.

## US-04 — Sign the fee bump with only the fee payer

As a service developer, I want to sign the fee bump transaction with only the fee payer's keypair (the inner transaction was already signed by the user), so that the signing responsibilities are separated between the two parties.

## US-05 — Submit the fee bump transaction via its dedicated method

As a service developer, I want to submit a fee bump transaction using `sdk.submitFeeBumpTransaction(feeBumpTx)`, so that it is broadcast to the network and the fee payer's account absorbs the fee.
