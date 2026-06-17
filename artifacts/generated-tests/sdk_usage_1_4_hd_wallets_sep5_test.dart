// Tests generated from documentation/sdk-usage.md § "HD Wallets (SEP-5)" (subtopic 1.4).
// Pipeline: US-01..03 → AC-01.1..AC-03.3 → SC-01.1..SC-03.2 → TS-01.1..TS-03.2
//
// AMB-1: Doc example mnemonic "cable spray genius state float ..." is a placeholder
//         truncated with "...". Tests generate real mnemonics dynamically.
// AMB-2: Index constraints (bounds, sign) not stated in docs. Tests use indices 0 and 1
//         (the only values shown in documentation examples).
// AMB-3: BIP-39/SLIP-0010 standard compliance — no test vectors provided in docs.
//         Determinism tests (TS-02.4, TS-03.2) are the closest testable proxy.
// AMB-4: "Keep both the mnemonic AND the passphrase safe" is advisory; not testable.
//
// All operations are local (CPU/crypto only) — no network calls, no FriendBot.

@Timeout(const Duration(seconds: 60))

import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

void main() {
  // -----------------------------------------------------------------------
  // US-01: Wallet.generate24WordsMnemonic() — generate a new mnemonic
  // -----------------------------------------------------------------------
  group('US-01: Wallet.generate24WordsMnemonic()', () {
    test('TS-01.1 — returns a non-empty string of exactly 24 space-separated words', () async {
      // AC-01.1 / AC-01.2 / AC-01.3 / SC-01.1
      final mnemonic = await Wallet.generate24WordsMnemonic();
      expect(mnemonic, isNotEmpty);
      expect(
        mnemonic.split(' ').length,
        equals(24),
        reason: 'Method name and documentation both specify 24 words',
      );
    });

    test('TS-01.2 — successive calls produce different mnemonic phrases', () async {
      // AC-01.4 / SC-01.2
      final m1 = await Wallet.generate24WordsMnemonic();
      final m2 = await Wallet.generate24WordsMnemonic();
      expect(
        m1,
        isNot(equals(m2)),
        reason: 'Random mnemonic generation must not produce a constant value',
      );
    });
  });

  // -----------------------------------------------------------------------
  // US-02: Wallet.from() + getKeyPair() — derive accounts from mnemonic
  // -----------------------------------------------------------------------
  group('US-02: Wallet.from() + getKeyPair() — derive accounts', () {
    late String _mnemonic;
    late Wallet _wallet;

    setUpAll(() async {
      _mnemonic = await Wallet.generate24WordsMnemonic();
      _wallet = await Wallet.from(_mnemonic);
    });

    test('TS-02.1 — Wallet.from() returns a non-null Wallet', () {
      // AC-02.1 / SC-02.1
      expect(_wallet, isNotNull);
    });

    test('TS-02.2 — getKeyPair(index: 0) returns a non-null KeyPair with G-prefixed accountId', () async {
      // AC-02.2 / AC-02.3 / SC-02.2
      final kp = await _wallet.getKeyPair(index: 0);
      expect(kp, isNotNull);
      expect(kp.accountId, startsWith('G'));
    });

    test('TS-02.3 — keypairs at index 0 and index 1 have different accountIds', () async {
      // AC-02.4 / SC-02.3
      // Doc shows m/44'/148'/0' and m/44'/148'/1' as distinct derivation paths.
      final kp0 = await _wallet.getKeyPair(index: 0);
      final kp1 = await _wallet.getKeyPair(index: 1);
      expect(
        kp0.accountId,
        isNot(equals(kp1.accountId)),
        reason: 'Each HD index must produce a distinct account',
      );
    });

    test('TS-02.4 — same mnemonic always produces the same accountId at the same index (determinism)', () async {
      // AC-02.5 / SC-02.4
      // Doc: "the same phrase always produces the same accounts"
      final wallet2 = await Wallet.from(_mnemonic);
      final kp0 = await _wallet.getKeyPair(index: 0);
      final kp0Again = await wallet2.getKeyPair(index: 0);
      expect(
        kp0Again.accountId,
        equals(kp0.accountId),
        reason: 'BIP-39/SLIP-0010 derivation must be deterministic',
      );
    });

    test('TS-02.5 — derived keypair can sign (has private key)', () async {
      // AC-02.6 / SC-02.5
      final kp = await _wallet.getKeyPair(index: 0);
      expect(
        kp.canSign(),
        isTrue,
        reason: 'HD derivation always produces a full keypair with private key',
      );
    });
  });

  // -----------------------------------------------------------------------
  // US-03: Wallet.from() with passphrase — second-factor security
  // -----------------------------------------------------------------------
  group('US-03: Wallet.from() with passphrase', () {
    late String _mnemonic;

    setUpAll(() async {
      _mnemonic = await Wallet.generate24WordsMnemonic();
    });

    test('TS-03.1 — same mnemonic with passphrase produces different accountId than without', () async {
      // AC-03.1 / AC-03.2 / SC-03.1
      // Doc: "the same mnemonic produces completely different accounts"
      const passphrase = 'my-secret-passphrase';
      final walletWith = await Wallet.from(_mnemonic, passphrase: passphrase);
      final walletNo = await Wallet.from(_mnemonic);
      final kpWith = await walletWith.getKeyPair(index: 0);
      final kpNo = await walletNo.getKeyPair(index: 0);
      expect(
        kpWith.accountId,
        isNot(equals(kpNo.accountId)),
        reason: 'Passphrase must act as a true second factor altering the derived accounts',
      );
    });

    test('TS-03.2 — same mnemonic + same passphrase always produces the same accountId (determinism with passphrase)', () async {
      // AC-03.3 / SC-03.2
      const passphrase = 'my-secret-passphrase';
      final wallet1 = await Wallet.from(_mnemonic, passphrase: passphrase);
      final wallet2 = await Wallet.from(_mnemonic, passphrase: passphrase);
      final kp1 = await wallet1.getKeyPair(index: 0);
      final kp2 = await wallet2.getKeyPair(index: 0);
      expect(
        kp1.accountId,
        equals(kp2.accountId),
        reason: 'BIP-39 determinism must hold when a passphrase is used',
      );
    });
  });
}
