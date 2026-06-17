// Tests generated from documentation/sdk-usage.md § "Funding Testnet Accounts" (subtopic 1.3).
// Pipeline: US-01 → AC-01.1..AC-01.5 → SC-01.1..SC-01.3 → TS-01.1..TS-01.3
//
// AMB-1: FriendBot.fundTestAccount() return type is not shown in the docs (bare await,
//         no return capture). Tests verify postconditions rather than a return value.
// AMB-2: Doc states exactly "10,000 test XLM"; closeTo(10000, 100) applied to accommodate
//         minimum reserve deductions without invalidating the documented claim.
// TL-1:  "Only works on testnet" constraint cannot be tested within a testnet suite.
// TL-2:  Re-funding behavior not documented; not tested.
//
// Design: setUpAll funds and loads one shared account for TS-01.2 and TS-01.3.
//         TS-01.1 funds a second fresh account independently so it directly exercises
//         the documented API call without relying on setUpAll having already done it.

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
    _account = await sdk.accounts.account(_funded.accountId);
  });

  // -----------------------------------------------------------------------
  // US-01: FriendBot.fundTestAccount() — fund a testnet account
  // -----------------------------------------------------------------------
  group('US-01: FriendBot.fundTestAccount() — fund a testnet account', () {
    test('TS-01.1 — call completes without throwing for a fresh testnet account', () async {
      // AC-01.1 / AC-01.2 / SC-01.1
      // AMB-1: return type not in docs; bare completion (no exception) is the verifiable outcome.
      // A second fresh keypair is funded here so this test directly exercises the documented call.
      final kp = KeyPair.random();
      await FriendBot.fundTestAccount(kp.accountId);
      // Reaching this point proves the call resolved successfully.
    });

    test('TS-01.2 — funded account is loadable on testnet (AccountResponse is not null)', () {
      // AC-01.3 / SC-01.2
      expect(_account, isNotNull);
    });

    test('TS-TL-1 — FriendBot funds testnet only: account exists on testnet, absent from mainnet', () async {
      // AC-TL-1 / SC-TL-1
      // Safety: mainnet call is read-only (account lookup via public Horizon). No XLM spent.
      final kp = KeyPair.random();
      await FriendBot.fundTestAccount(kp.accountId);

      final testnetAccount = await sdk.accounts.account(kp.accountId);
      expect(testnetAccount, isNotNull);

      await expectLater(
        StellarSDK.PUBLIC.accounts.account(kp.accountId),
        throwsA(anything),
        reason: 'FriendBot is documented to work on testnet only; account must not exist on mainnet',
      );
    });

    test('TS-01.3 — native XLM balance is approximately 10,000 (doc: "funds new accounts with 10,000 test XLM")', () {
      // AC-01.4 / SC-01.3
      // AMB-2: closeTo(10000, 100) allows ±100 XLM for minimum reserve effects.
      final native =
          _account.balances.firstWhere((b) => b.assetType == Asset.TYPE_NATIVE);
      final xlm = double.parse(native.balance);
      expect(
        xlm,
        closeTo(10000, 100),
        reason: 'FriendBot is documented to fund with 10,000 test XLM',
      );
    });
  });
}
