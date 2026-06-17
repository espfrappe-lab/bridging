# Stage 3 — Gherkin Scenarios
## Subtopic 1.5: Muxed Accounts
**Source:** `documentation/sdk-usage.md` § "Muxed Accounts"

---

## US-01 — Construct a MuxedAccount

```gherkin
Scenario SC-01.1: MuxedAccount constructor returns a non-null object
  Given a valid Stellar G-address (obtained via KeyPair.random().accountId)
  And a BigInt user ID of 123456789
  When MuxedAccount(address, BigInt.from(123456789)) is called
  Then the result should be non-null

Scenario SC-01.2: Constructed MuxedAccount has an M-prefixed accountId
  Given a MuxedAccount created from a G-address and BigInt ID 123456789
  When the .accountId property is read
  Then it should start with the character 'M'

Scenario SC-01.3: Constructed MuxedAccount round-trips the numeric ID
  Given a MuxedAccount created with BigInt.from(123456789)
  When the .id property is read
  Then it should equal BigInt.from(123456789)

Scenario SC-01.4: Constructed MuxedAccount round-trips the base G-address
  Given a MuxedAccount created from a G-address baseAddress
  When the .ed25519AccountId property is read
  Then it should equal baseAddress
```

---

## US-02 — Parse an M-address

```gherkin
Scenario SC-02.1: MuxedAccount.fromAccountId() returns a non-null object for a valid M-address
  Given a MuxedAccount constructed from baseAddress and BigInt.from(123456789)
  And its .accountId (an M-address) has been stored as mAddress
  When MuxedAccount.fromAccountId(mAddress) is called
  Then the result should be non-null

Scenario SC-02.2: Parsed MuxedAccount recovers the original base G-address
  Given a MuxedAccount parsed from a valid M-address
  When the parsed object's .ed25519AccountId property is read
  Then it should equal the G-address used to construct the M-address

Scenario SC-02.3: Parsed MuxedAccount recovers the original numeric ID
  Given a MuxedAccount parsed from a valid M-address encoding ID 123456789
  When the parsed object's .id property is read
  Then it should equal BigInt.from(123456789)

Scenario SC-02.4: Parsed MuxedAccount's accountId is self-consistent with the input
  Given a MuxedAccount parsed from mAddress
  When the parsed object's .accountId property is read
  Then it should equal mAddress
```

---

## US-03 — Use muxed address as a payment destination

```gherkin
Scenario SC-03.1: PaymentOperationBuilder accepts an M-address as destination without throwing
  Given a MuxedAccount constructed from a G-address and a BigInt ID
  And its M-address has been read from .accountId
  When PaymentOperationBuilder(mAddress, Asset.NATIVE, "100") is called
  And .build() is called on the builder
  Then no exception should be thrown
  And the returned Operation should be non-null
```

---

## Notes

- All scenarios are synchronous and local — no network, no FriendBot.
- SC-01.1 through SC-01.4 share the same setup; they are separated to produce
  independent, named test entries per AC.
- SC-02.1 through SC-02.4 likewise share setup (one MuxedAccount constructed,
  one M-address parsed) and are separated per AC.
- SC-03.1 covers both AC-03.1 and AC-03.2 because `.build()` is the only observable
  outcome of the PaymentOperationBuilder usage documented.
