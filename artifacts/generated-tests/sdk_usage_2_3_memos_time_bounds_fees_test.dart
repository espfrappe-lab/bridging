@Timeout(const Duration(seconds: 300))

import 'dart:typed_data';
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

  // TS-01.1 — US-01 / AC-01.1
  test('TS-01.1 — Memo.text() returns a non-null MemoText with preserved text',
      () {
    Memo memo = Memo.text('Payment for invoice #1234');

    expect(memo, isNotNull);
    expect(memo, isA<MemoText>());
    expect((memo as MemoText).text, 'Payment for invoice #1234');
  });

  // TS-02.1 — US-01, US-02 / AC-01.2, AC-01.3, AC-02.1–AC-02.5
  test(
      'TS-02.1 — Text memo round-trip: submitted memo is retrievable with correct type and text',
      () async {
    AccountResponse senderAccount =
        await sdk.accounts.account(sender.accountId);

    Transaction tx = TransactionBuilder(senderAccount)
        .addOperation(
            PaymentOperationBuilder(receiver.accountId, Asset.NATIVE, '1')
                .build())
        .addMemo(Memo.text('Payment for invoice #1234'))
        .build();

    tx.sign(sender, Network.TESTNET);
    SubmitTransactionResponse response = await sdk.submitTransaction(tx);

    expect(response.success, true);
    expect(response.hash, isNotNull);

    TransactionResponse txResponse =
        await sdk.transactions.transaction(response.hash!);
    Memo? memo = txResponse.memo;

    expect(memo, isNotNull);
    expect(memo is MemoText, true);
    expect((memo as MemoText).text, 'Payment for invoice #1234');
  });

  // TS-03.1 — US-03 / AC-03.1
  test('TS-03.1 — Memo.id() returns a non-null memo for a numeric id', () {
    Memo memo = Memo.id(12345);
    expect(memo, isNotNull);
  });

  // TS-03.2 — US-03 / AC-03.2, AC-03.3
  test(
      'TS-03.2 — Memo.hash() and Memo.returnHash() accept 32-byte Uint8List values',
      () {
    Uint8List bytes = Uint8List(32);

    Memo hashMemo = Memo.hash(bytes);
    Memo returnHashMemo = Memo.returnHash(bytes);

    expect(hashMemo, isNotNull);
    expect(returnHashMemo, isNotNull);
  });

  // TS-04.1 — US-04 / AC-04.1, AC-04.2
  test(
      'TS-04.1 — TimeBounds constructor and addTimeBounds() do not throw',
      () async {
    AccountResponse senderAccount =
        await sdk.accounts.account(sender.accountId);

    int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    TimeBounds timeBounds = TimeBounds(now - 60, now + 300);

    expect(
      () => TransactionBuilder(senderAccount)
          .addOperation(
              PaymentOperationBuilder(receiver.accountId, Asset.NATIVE, '1')
                  .build())
          .addTimeBounds(timeBounds)
          .build(),
      returnsNormally,
    );
  });

  // TS-04.2 — US-04 / AC-04.3
  test(
      'TS-04.2 — Transaction with valid time bounds submits successfully',
      () async {
    AccountResponse senderAccount =
        await sdk.accounts.account(sender.accountId);

    int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    TimeBounds timeBounds = TimeBounds(now - 60, now + 300);

    Transaction tx = TransactionBuilder(senderAccount)
        .addOperation(
            PaymentOperationBuilder(receiver.accountId, Asset.NATIVE, '1')
                .build())
        .addTimeBounds(timeBounds)
        .build();

    tx.sign(sender, Network.TESTNET);
    SubmitTransactionResponse response = await sdk.submitTransaction(tx);

    expect(response.success, true);
  });

  // TS-05.1 — US-05 / AC-05.1
  test(
      'TS-05.1 — setMaxOperationFee(200) does not throw when building a transaction',
      () async {
    AccountResponse senderAccount =
        await sdk.accounts.account(sender.accountId);

    expect(
      () => TransactionBuilder(senderAccount)
          .addOperation(
              PaymentOperationBuilder(receiver.accountId, Asset.NATIVE, '1')
                  .build())
          .setMaxOperationFee(200)
          .build(),
      returnsNormally,
    );
  });

  // TS-05.2 — US-05 / AC-05.2
  test(
      'TS-05.2 — Transaction with custom fee (200 stroops) submits successfully',
      () async {
    AccountResponse senderAccount =
        await sdk.accounts.account(sender.accountId);

    Transaction tx = TransactionBuilder(senderAccount)
        .addOperation(
            PaymentOperationBuilder(receiver.accountId, Asset.NATIVE, '1')
                .build())
        .setMaxOperationFee(200)
        .build();

    tx.sign(sender, Network.TESTNET);
    SubmitTransactionResponse response = await sdk.submitTransaction(tx);

    expect(response.success, true);
  });
}
