# Stage 1 — User Stories: 2.1 Simple Payments

Source: `documentation/sdk-usage.md` §Simple Payments, `documentation/getting-started.md` §Complete Payment Example, `documentation/quick-start.md` §Complete Example

---

**US-01:** As a developer, I want to build a native XLM payment operation by specifying a destination address, asset type, and amount, so that I can describe the payment my transaction will carry.

**US-02:** As a developer, I want to wrap a payment operation in a transaction bound to a source account, so that the network knows who authorizes and pays the fee for the transfer.

**US-03:** As a developer, I want to sign the transaction with the sender's keypair and the correct network passphrase, so that the network can verify the transaction is authorized.

**US-04:** As a developer, I want to submit the signed transaction to Horizon and receive a success flag and a transaction hash, so that I can confirm the payment executed on-chain.

**US-05:** As a developer, I want to verify the recipient's native XLM balance after a successful payment, so that I can confirm the funds arrived in the destination account.

**US-06:** As a developer, I want to attach a text memo to a payment transaction, so that I can include a human-readable payment reference alongside the transfer.
