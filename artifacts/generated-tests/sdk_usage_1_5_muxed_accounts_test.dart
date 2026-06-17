// Tests generated from documentation/sdk-usage.md § "Muxed Accounts" (subtopic 1.5).
// Pipeline: US-01..03 → AC-01.1..AC-03.2 → SC-01.1..SC-03.1 → TS-01.1..TS-03.1
//
// AMB-1: Doc uses placeholder G-address "GABC...". Tests use KeyPair.random().accountId.
// AMB-2: fromAccountId() returns MuxedAccount? — docs do not describe the invalid-input
//         path. Only the happy path (valid M-address input) is tested.
// AMB-3: Doc uses BigInt.from(123456789) as the example ID; tests use the same value.
// AMB-4: Doc uses placeholder M-address "MABC...". Tests derive a real M-address by
//         first constructing a MuxedAccount and reading .accountId.
//
// All operations are local (no network calls, no FriendBot).

@Timeout(const Duration(seconds: 30))

import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

void main() {
  // -----------------------------------------------------------------------
  // US-01: MuxedAccount constructor — create a muxed account
  // -----------------------------------------------------------------------
  group('US-01: MuxedAccount constructor', () {
    late String baseAddress;
    late MuxedAccount muxedAccount;

    setUpAll(() {
      // AMB-1: placeholder replaced with a real G-address
      baseAddress = KeyPair.random().accountId;
      muxedAccount = MuxedAccount(baseAddress, BigInt.from(123456789));
    });

    test('TS-01.1 — constructor returns a non-null object', () {
      // AC-01.1 / SC-01.1
      expect(muxedAccount, isNotNull);
    });

    test('TS-01.2 — accountId begins with M', () {
      // AC-01.2 / SC-01.2
      expect(
        muxedAccount.accountId,
        startsWith('M'),
        reason: 'Docs: muxed address (M...) encodes both base account and 64-bit user ID',
      );
    });

    test('TS-01.3 — id round-trips the numeric ID', () {
      // AC-01.3 / SC-01.3
      expect(
        muxedAccount.id,
        equals(BigInt.from(123456789)),
        reason: '.id must return exactly the BigInt passed to the constructor',
      );
    });

    test('TS-01.4 — ed25519AccountId round-trips the base G-address', () {
      // AC-01.4 / SC-01.4
      expect(
        muxedAccount.ed25519AccountId,
        equals(baseAddress),
        reason: '.ed25519AccountId must equal the G-address used to construct the muxed account',
      );
    });
  });

  // -----------------------------------------------------------------------
  // US-02: MuxedAccount.fromAccountId() — parse an M-address
  // -----------------------------------------------------------------------
  group('US-02: MuxedAccount.fromAccountId()', () {
    late String baseAddress;
    late String mAddress;
    late MuxedAccount? parsed;

    setUpAll(() {
      // AMB-4: derive a real M-address from a real MuxedAccount
      baseAddress = KeyPair.random().accountId;
      final created = MuxedAccount(baseAddress, BigInt.from(123456789));
      mAddress = created.accountId;
      parsed = MuxedAccount.fromAccountId(mAddress);
    });

    test('TS-02.1 — fromAccountId() returns non-null for a valid M-address', () {
      // AC-02.1 / SC-02.1
      expect(parsed, isNotNull);
    });

    test('TS-02.2 — parsed object recovers original base G-address', () {
      // AC-02.2 / SC-02.2
      expect(
        parsed!.ed25519AccountId,
        equals(baseAddress),
        reason: 'Round-trip: G-address must survive MuxedAccount creation → encoding → parsing',
      );
    });

    test('TS-02.3 — parsed object recovers original numeric ID', () {
      // AC-02.3 / SC-02.3
      expect(
        parsed!.id,
        equals(BigInt.from(123456789)),
        reason: 'Round-trip: 64-bit ID must survive MuxedAccount creation → encoding → parsing',
      );
    });

    test('TS-02.4 — parsed object\'s accountId equals the input M-address', () {
      // AC-02.4 / SC-02.4
      expect(
        parsed!.accountId,
        equals(mAddress),
        reason: 'Self-consistency: accountId of the parsed object must match the M-address fed in',
      );
    });
  });

  // -----------------------------------------------------------------------
  // US-03: M-address as a payment destination
  // -----------------------------------------------------------------------
  group('US-03: M-address as PaymentOperationBuilder destination', () {
    test('TS-03.1 — PaymentOperationBuilder accepts M-address and build() returns non-null', () {
      // AC-03.1 / AC-03.2 / SC-03.1
      final base = KeyPair.random().accountId;
      final muxed = MuxedAccount(base, BigInt.from(123456789));
      final mAddress = muxed.accountId;

      // Docs show: PaymentOperationBuilder(muxedAccount.accountId, Asset.NATIVE, "100").build()
      final op = PaymentOperationBuilder(mAddress, Asset.NATIVE, '100').build();
      expect(op, isNotNull);
    });
  });
}
