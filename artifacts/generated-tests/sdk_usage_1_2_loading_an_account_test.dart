// Tests generated from documentation/sdk-usage.md § "Loading an Account" (subtopic 1.2).
// Pipeline: US-01..03 → AC-01.1..AC-03.4 → SC-01.1..SC-03.4 → TS-01.1..TS-03.4
//
// Design note — test layer:
// Section 1.2 describes live Horizon API calls. There is no non-network API
// surface to unit-test in isolation. These tests follow the benchmark convention:
// flutter_test framework, real testnet calls, FriendBot setup, 600 s timeout.
//
// AMB-1: balance.assetCode (non-native else-branch) cannot be exercised with a
//         freshly funded account (no trustlines). Covered at field-access level only.
// AMB-2: AccountResponse.sequenceNumber type not stated in docs. The oracle
//         (integer-parseable) is derived from the stated purpose: "required when
//         building transactions".

@Timeout(const Duration(seconds: 600))

import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

void main() {
  final StellarSDK sdk = StellarSDK.TESTNET;

  late KeyPair _funded;
  late AccountResponse _account;

  setUpAll(() async {
    _funded = KeyPair.random();
    await FriendBot.fundTestAccount(_funded.accountId);
    // Cache the loaded account to share across US-01 and US-02 tests,
    // avoiding redundant network calls.
    _account = await sdk.accounts.account(_funded.accountId);
  });

  // -----------------------------------------------------------------------
  // US-01: Load a Stellar account from the network
  // -----------------------------------------------------------------------
  group('US-01: sdk.accounts.account() — load account data', () {
    test('TS-01.1 — returns a non-null AccountResponse for a funded account', () {
      // AC-01.1 / SC-01.1
      expect(_account, isNotNull);
    });

    test('TS-01.2 — sequenceNumber is non-null', () {
      // AC-01.2 / AC-01.3 / SC-01.2
      expect(_account.sequenceNumber, isNotNull);
    });

    test('TS-01.3 — sequenceNumber is integer-parseable (invariant: required for transaction building)', () {
      // AC-01.4 / SC-01.3
      // AMB-2: type not declared in docs; oracle derived from stated purpose.
      final repr = _account.sequenceNumber.toString();
      expect(repr, isNotEmpty);
      expect(
        int.tryParse(repr),
        isNotNull,
        reason: 'sequenceNumber must parse as int — it is "required when building transactions"',
      );
    });
  });

  // -----------------------------------------------------------------------
  // US-02: Iterate and inspect account balances
  // -----------------------------------------------------------------------
  group('US-02: AccountResponse.balances — balance inspection', () {
    test('TS-02.1 — balances list is non-empty', () {
      // AC-02.1 / AC-02.6 / SC-02.1
      expect(_account.balances, isNotEmpty);
    });

    test('TS-02.2 — at least one balance has assetType == Asset.TYPE_NATIVE', () {
      // AC-02.4 / AC-02.6 / SC-02.2
      final nativeEntries = _account.balances
          .where((b) => b.assetType == Asset.TYPE_NATIVE)
          .toList();
      expect(
        nativeEntries,
        isNotEmpty,
        reason: 'A FriendBot-funded account must carry a native XLM balance entry',
      );
    });

    test('TS-02.3 — native XLM balance is greater than zero', () {
      // AC-02.3 / AC-02.7 / SC-02.3
      final native =
          _account.balances.firstWhere((b) => b.assetType == Asset.TYPE_NATIVE);
      expect(double.parse(native.balance), greaterThan(0));
    });

    test('TS-02.4 — every balance entry exposes assetType and balance fields without throwing', () {
      // AC-02.2 / AC-02.3 / SC-02.4
      // AMB-1: assetCode on non-native entries not exercisable without a trustline.
      for (final balance in _account.balances) {
        expect(balance.assetType, isNotNull);
        expect(balance.balance, isNotNull);
      }
    });
  });

  // -----------------------------------------------------------------------
  // US-03: Check account existence via try/catch on ErrorResponse
  // -----------------------------------------------------------------------
  group('US-03: account existence check — try/catch on ErrorResponse', () {
    late String _nonExistentId;

    setUp(() {
      // Freshly generated, never-funded keypair: guaranteed non-existent on testnet.
      _nonExistentId = KeyPair.random().accountId;
    });

    test('TS-03.1 — non-existent account throws ErrorResponse', () async {
      // AC-03.1 / SC-03.1
      Object? caught;
      try {
        await sdk.accounts.account(_nonExistentId);
      } catch (e) {
        caught = e;
      }
      expect(caught, isA<ErrorResponse>());
    });

    test('TS-03.2 — thrown ErrorResponse has code 404', () async {
      // AC-03.2 / SC-03.2
      try {
        await sdk.accounts.account(_nonExistentId);
        fail('Expected an ErrorResponse to be thrown for a non-existent account');
      } on ErrorResponse catch (e) {
        expect(e.code, equals(404));
      }
    });

    test('TS-03.3 — documented try/catch pattern: non-existent account sets exists = false', () async {
      // AC-03.3 / SC-03.3 — reproduces the exact pattern shown in the documentation
      bool exists = true;
      try {
        await sdk.accounts.account(_nonExistentId);
      } on ErrorResponse catch (e) {
        if (e.code == 404) exists = false;
      }
      expect(exists, isFalse);
    });

    test('TS-03.4 — documented try/catch pattern: existing account keeps exists = true', () async {
      // AC-03.4 / SC-03.4
      bool exists = true;
      try {
        await sdk.accounts.account(_funded.accountId);
      } on ErrorResponse catch (e) {
        if (e.code == 404) exists = false;
      }
      expect(exists, isTrue);
    });
  });
}
