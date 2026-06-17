# Stage 1 — User Stories
## Subtopic 1.5: Muxed Accounts
**Source:** `documentation/sdk-usage.md` § "Muxed Accounts"

---

**US-01:** As a developer, I want to construct a `MuxedAccount` from a base G-address
and a 64-bit numeric ID so that I can obtain the encoded M-address that identifies a
specific virtual user sharing that base account.

**US-02:** As a developer, I want to parse an existing M-address string back into a
`MuxedAccount` object via `MuxedAccount.fromAccountId()` so that I can extract the
underlying base G-address and 64-bit ID it encodes.

**US-03:** As a developer, I want to use a muxed account's M-address as a payment
destination in a `PaymentOperationBuilder` so that I can direct payments to a
specific virtual user on a shared base account.

---

> **Domain context (from docs):**
> "Muxed accounts let multiple virtual users share one Stellar account. Useful for
> exchanges and payment processors that need to track many users without creating
> separate accounts for each. The muxed address (M...) encodes both the base account
> and a 64-bit user ID."
>
> All MuxedAccount operations are synchronous and local — no network connectivity required.
