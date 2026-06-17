@Timeout(const Duration(seconds: 300))

import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

void main() {
  StellarSDK sdk = StellarSDK.TESTNET;

  late KeyPair userKeyPair;
  late KeyPair dest1KeyPair;
  late KeyPair dest2KeyPair;
  late KeyPair feePayerKeyPair;

  setUpAll(() async {
    userKeyPair = KeyPair.random();
    dest1KeyPair = KeyPair.random();
    dest2KeyPair = KeyPair.random();
    feePayerKeyPair = KeyPair.random();
    await FriendBot.fundTestAccount(userKeyPair.accountId);
    await FriendBot.fundTestAccount(dest1KeyPair.accountId);
    await FriendBot.fundTestAccount(dest2KeyPair.accountId);
    await FriendBot.fundTestAccount(feePayerKeyPair.accountId);
  });

  // TS-01.1 — US-01, US-02, US-03 / AC-01.1, AC-01.2, AC-02.1, AC-03.1
  test(
      'TS-01.1 — FeeBumpTransactionBuilder returns a non-null FeeBumpTransaction',
      () async {
    AccountResponse userAccount =
        await sdk.accounts.account(userKeyPair.accountId);

    Transaction innerTransaction = TransactionBuilder(userAccount)
        .addOperation(PaymentOperationBuilder(
          dest1KeyPair.accountId,
          Asset.NATIVE,
          '10',
        ).build())
        .addOperation(PaymentOperationBuilder(
          dest2KeyPair.accountId,
          Asset.NATIVE,
          '20',
        ).build())
        .build();

    innerTransaction.sign(userKeyPair, Network.TESTNET);

    FeeBumpTransaction feeBumpTx =
        FeeBumpTransactionBuilder(innerTransaction)
            .setBaseFee(300)
            .setFeeAccount(feePayerKeyPair.accountId)
            .build();

    expect(feeBumpTx, isNotNull);
    expect(feeBumpTx, isA<FeeBumpTransaction>());
  });

  // TS-04.1 — US-04 / AC-04.1, AC-04.2
  test(
      'TS-04.1 — feeBumpTx.sign(feePayerKeyPair, TESTNET) does not throw',
      () async {
    AccountResponse userAccount =
        await sdk.accounts.account(userKeyPair.accountId);

    Transaction innerTransaction = TransactionBuilder(userAccount)
        .addOperation(PaymentOperationBuilder(
          dest1KeyPair.accountId,
          Asset.NATIVE,
          '10',
        ).build())
        .addOperation(PaymentOperationBuilder(
          dest2KeyPair.accountId,
          Asset.NATIVE,
          '20',
        ).build())
        .build();

    innerTransaction.sign(userKeyPair, Network.TESTNET);

    FeeBumpTransaction feeBumpTx =
        FeeBumpTransactionBuilder(innerTransaction)
            .setBaseFee(300)
            .setFeeAccount(feePayerKeyPair.accountId)
            .build();

    expect(
      () => feeBumpTx.sign(feePayerKeyPair, Network.TESTNET),
      returnsNormally,
    );
  });

  // TS-02.1 — US-04, US-05 / AC-02.2, AC-04.2, AC-05.1, AC-05.2
  // baseFee = 300 = (100 * 2 inner ops) + 100 — documented minimum fee formula
  test(
      'TS-02.1 — Fee bump wrapping 2-op inner tx submits successfully via submitFeeBumpTransaction',
      () async {
    AccountResponse userAccount =
        await sdk.accounts.account(userKeyPair.accountId);

    // User builds and signs the inner transaction (two payments)
    Transaction innerTransaction = TransactionBuilder(userAccount)
        .addOperation(PaymentOperationBuilder(
          dest1KeyPair.accountId,
          Asset.NATIVE,
          '10',
        ).build())
        .addOperation(PaymentOperationBuilder(
          dest2KeyPair.accountId,
          Asset.NATIVE,
          '20',
        ).build())
        .build();

    innerTransaction.sign(userKeyPair, Network.TESTNET);

    // Fee payer wraps the inner transaction
    FeeBumpTransaction feeBumpTx =
        FeeBumpTransactionBuilder(innerTransaction)
            .setBaseFee(300)
            .setFeeAccount(feePayerKeyPair.accountId)
            .build();

    // Only the fee payer signs the fee bump
    feeBumpTx.sign(feePayerKeyPair, Network.TESTNET);

    SubmitTransactionResponse response =
        await sdk.submitFeeBumpTransaction(feeBumpTx);

    expect(response.success, true);
  });
}
