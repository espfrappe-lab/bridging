# Stage 1 — User Stories
## Subtopic 1.6: Connecting to Networks
**Source:** `documentation/sdk-usage.md` § "Connecting to Networks"

---

**US-01:** As a developer, I want to obtain a `StellarSDK` instance for the Testnet
and a `Network.TESTNET` passphrase object so that I can build and sign transactions
for development and testing without affecting production funds.

**US-02:** As a developer, I want to obtain a `StellarSDK` instance for the Public
network and a `Network.PUBLIC` passphrase object so that I can submit real
transactions to the production Stellar network.

**US-03:** As a developer, I want to obtain a `StellarSDK` instance for the Futurenet
and a `Network.FUTURENET` passphrase object so that I can preview upcoming Stellar
protocol features before they reach the public network.

**US-04:** As a developer, I want to construct a `StellarSDK` instance pointing at a
custom Horizon server URL so that I can connect to non-standard deployments (e.g. a
private Stellar network or a self-hosted Horizon node).

---

> **Domain context (from docs):**
> "Stellar has multiple networks, each with its own Horizon server and network
> passphrase. Use testnet for development, public for production. The network
> passphrase is used when signing transactions."
>
> All four capabilities are synchronous object-construction calls — no network I/O is
> needed to instantiate an SDK or Network constant.
