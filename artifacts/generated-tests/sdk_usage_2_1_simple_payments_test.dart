@Timeout(const Duration(seconds: 300))

import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

void main() {
  StellarSDK sdk = StellarSDK.TESTNET;

  late KeyPair sender;
  late KeyPair receiver;

  setUpAll(() async {
    sender = KeyPair.random();
    receiver = KeyPair.random();
    await FriendBot.fundTestAccount(sender.accountId);
    await FriendBot.fundTestAccount(receiver.accountId);
  });

  // TS-01.1 — US-01 / AC-01.1, AC-01.2, AC-01.3
  test(
      'TS-01.1 — PaymentOperationBuilder returns a non-null PaymentOperation',
      () {
    PaymentOperation op = PaymentOperationBuilder(
      receiver.accountId,
      Asset.NATIVE,
      '100.50',
    ).build();

    expect(op, isNotNull);
    expect(op, isA<PaymentOperation>());
  });

  // TS-02.1 — US-02 / AC-02.1, AC-02.2
  test(
      'TS-02.1 — TransactionBuilder wraps payment into a single-operation transaction',
      () async {
    AccountResponse senderAccount =
        await sdk.accounts.account(sender.accountId);

    PaymentOperation op = PaymentOperationBuilder(
      receiver.accountId,
      Asset.NATIVE,
      '10',
    ).build();

    Transaction tx = TransactionBuilder(senderAccount)
        .addOperation(op)
        .build();

    expect(tx, isNotNull);
    expect(tx.operations.length, 1);
  });

  // TS-03.1 — US-03 / AC-03.1
  test(
      'TS-03.1 — Signing with Network.TESTNET does not throw',
      () async {
    AccountResponse senderAccount =
        await sdk.accounts.account(sender.accountId);

    Transaction tx = TransactionBuilder(senderAccount)
        .addOperation(
          PaymentOperationBuilder(receiver.accountId, Asset.NATIVE, '1')
              .build(),
        )
        .build();

    expect(() => tx.sign(sender, Network.TESTNET), returnsNormally);
  });

  // TS-04.1 — US-03, US-04 / AC-04.1, AC-04.2, AC-04.3
  test(
      'TS-04.1 — Submitting a valid signed XLM payment returns success=true and a non-empty hash',
      () async {
    AccountResponse senderAccount =
        await sdk.accounts.account(sender.accountId);

    PaymentOperation op = PaymentOperationBuilder(
      receiver.accountId,
      Asset.NATIVE,
      '100.50',
    ).build();

    Transaction tx = TransactionBuilder(senderAccount)
        .addOperation(op)
        .build();

    tx.sign(sender, Network.TESTNET);

    SubmitTransactionResponse response = await sdk.submitTransaction(tx);

    expect(response.success, true);
    expect(response.hash, isNotNull);
    expect(response.hash, isNotEmpty);
  });

  // TS-05.1 — US-05 / AC-05.1, AC-05.2
  test(
      'TS-05.1 — Recipient native balance increases by the payment amount after a successful transfer',
      () async {
    KeyPair alice = KeyPair.random();
    KeyPair bob = KeyPair.random();
    await FriendBot.fundTestAccount(alice.accountId);
    await FriendBot.fundTestAccount(bob.accountId);

    AccountResponse aliceAccount =
        await sdk.accounts.account(alice.accountId);

    PaymentOperation op = PaymentOperationBuilder(
      bob.accountId,
      Asset.NATIVE,
      '100',
    ).build();

    Transaction tx = TransactionBuilder(aliceAccount)
        .addOperation(op)
        .build();

    tx.sign(alice, Network.TESTNET);
    SubmitTransactionResponse response = await sdk.submitTransaction(tx);
    expect(response.success, true);

    AccountResponse bobAccount = await sdk.accounts.account(bob.accountId);
    expect(bobAccount, isNotNull);

    double bobNativeBalance = 0;
    for (Balance balance in bobAccount.balances) {
      if (balance.assetType == Asset.TYPE_NATIVE) {
        bobNativeBalance = double.parse(balance.balance);
      }
    }
    expect(bobNativeBalance, greaterThanOrEqualTo(10100.0));
  });

  // TS-06.1 — US-06 / AC-06.1, AC-06.2
  test(
      'TS-06.1 — Payment transaction with a text memo submits successfully',
      () async {
    AccountResponse senderAccount =
        await sdk.accounts.account(sender.accountId);

    PaymentOperation op = PaymentOperationBuilder(
      receiver.accountId,
      Asset.NATIVE,
      '100',
    ).build();

    Transaction tx = TransactionBuilder(senderAccount)
        .addOperation(op)
        .addMemo(Memo.text('Coffee payment'))
        .build();

    tx.sign(sender, Network.TESTNET);
    SubmitTransactionResponse response = await sdk.submitTransaction(tx);

    expect(response.success, true);
    expect(response.hash, isNotNull);
  });
}
