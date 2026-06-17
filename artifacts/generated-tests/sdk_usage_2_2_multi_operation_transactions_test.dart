@Timeout(const Duration(seconds: 300))

import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

void main() {
  StellarSDK sdk = StellarSDK.TESTNET;

  // Shared issuer/funder — also acts as the USD asset issuer so it can
  // send USD in the payment operation without needing a separate trustline.
  late KeyPair issuerKeyPair;

  setUpAll(() async {
    issuerKeyPair = KeyPair.random();
    await FriendBot.fundTestAccount(issuerKeyPair.accountId);
  });

  // TS-01.1 — US-01 / AC-01.1, AC-01.2
  test(
      'TS-01.1 — CreateAccountOperationBuilder returns a non-null CreateAccountOperation',
      () {
    String newAccountId = KeyPair.random().accountId;

    CreateAccountOperation op =
        CreateAccountOperationBuilder(newAccountId, '5').build();

    expect(op, isNotNull);
    expect(op, isA<CreateAccountOperation>());
  });

  // TS-02.1 — US-02 / AC-02.1, AC-02.2, AC-02.3
  test(
      'TS-02.1 — ChangeTrustOperationBuilder with setSourceAccount returns a non-null ChangeTrustOperation',
      () {
    Asset usdAsset =
        AssetTypeCreditAlphaNum4('USD', issuerKeyPair.accountId);
    String newAccountId = KeyPair.random().accountId;

    ChangeTrustOperation op =
        ChangeTrustOperationBuilder(usdAsset, '10000')
            .setSourceAccount(newAccountId)
            .build();

    expect(op, isNotNull);
    expect(op, isA<ChangeTrustOperation>());
  });

  // TS-03.1 — US-03 / AC-03.1
  test(
      'TS-03.1 — PaymentOperationBuilder for a custom asset returns a non-null PaymentOperation',
      () {
    Asset usdAsset =
        AssetTypeCreditAlphaNum4('USD', issuerKeyPair.accountId);
    String newAccountId = KeyPair.random().accountId;

    PaymentOperation op =
        PaymentOperationBuilder(newAccountId, usdAsset, '100').build();

    expect(op, isNotNull);
    expect(op, isA<PaymentOperation>());
  });

  // TS-04.1 — US-04 / AC-04.1, AC-04.2
  test(
      'TS-04.1 — Transaction built with three operations contains exactly three operations',
      () async {
    KeyPair newAccountKeyPair = KeyPair.random();
    String newAccountId = newAccountKeyPair.accountId;
    Asset usdAsset =
        AssetTypeCreditAlphaNum4('USD', issuerKeyPair.accountId);

    AccountResponse funder =
        await sdk.accounts.account(issuerKeyPair.accountId);

    CreateAccountOperation createOp =
        CreateAccountOperationBuilder(newAccountId, '5').build();
    ChangeTrustOperation trustOp =
        ChangeTrustOperationBuilder(usdAsset, '10000')
            .setSourceAccount(newAccountId)
            .build();
    PaymentOperation paymentOp =
        PaymentOperationBuilder(newAccountId, usdAsset, '100').build();

    Transaction tx = TransactionBuilder(funder)
        .addOperation(createOp)
        .addOperation(trustOp)
        .addOperation(paymentOp)
        .build();

    expect(tx, isNotNull);
    expect(tx.operations.length, 3);
  });

  // TS-05.1 — US-05 / AC-05.1, AC-05.2
  test(
      'TS-05.1 — Signing the transaction with two keypairs does not throw',
      () async {
    KeyPair newAccountKeyPair = KeyPair.random();
    String newAccountId = newAccountKeyPair.accountId;
    Asset usdAsset =
        AssetTypeCreditAlphaNum4('USD', issuerKeyPair.accountId);

    AccountResponse funder =
        await sdk.accounts.account(issuerKeyPair.accountId);

    Transaction tx = TransactionBuilder(funder)
        .addOperation(
            CreateAccountOperationBuilder(newAccountId, '5').build())
        .addOperation(
            ChangeTrustOperationBuilder(usdAsset, '10000')
                .setSourceAccount(newAccountId)
                .build())
        .build();

    expect(() {
      tx.sign(issuerKeyPair, Network.TESTNET);
      tx.sign(newAccountKeyPair, Network.TESTNET);
    }, returnsNormally);
  });

  // TS-06.1 — US-05, US-06, US-07 / AC-06.1, AC-07.1, AC-07.2
  test(
      'TS-06.1 — Three-operation multi-sig transaction submits successfully and new account is verifiable',
      () async {
    KeyPair newAccountKeyPair = KeyPair.random();
    String newAccountId = newAccountKeyPair.accountId;
    Asset usdAsset =
        AssetTypeCreditAlphaNum4('USD', issuerKeyPair.accountId);

    AccountResponse funder =
        await sdk.accounts.account(issuerKeyPair.accountId);

    // 1. Create the new account
    CreateAccountOperation createOp =
        CreateAccountOperationBuilder(newAccountId, '5').build();

    // 2. New account establishes trustline for USD
    ChangeTrustOperation trustOp =
        ChangeTrustOperationBuilder(usdAsset, '10000')
            .setSourceAccount(newAccountId)
            .build();

    // 3. Issuer/funder sends 100 USD to new account
    PaymentOperation paymentOp =
        PaymentOperationBuilder(newAccountId, usdAsset, '100').build();

    Transaction transaction = TransactionBuilder(funder)
        .addOperation(createOp)
        .addOperation(trustOp)
        .addOperation(paymentOp)
        .build();

    // Both must sign: funder (tx source + create + payment) and new account
    // (source of the trustline operation)
    transaction.sign(issuerKeyPair, Network.TESTNET);
    transaction.sign(newAccountKeyPair, Network.TESTNET);

    SubmitTransactionResponse response =
        await sdk.submitTransaction(transaction);

    expect(response.success, true);

    AccountResponse newAccount =
        await sdk.accounts.account(newAccountId);
    expect(newAccount, isNotNull);
    expect(newAccount.accountId, newAccountId);
  });

  // TS-06.2 — US-06 / AC-06.2
  test(
      'TS-06.2 — atomic rollback: a failing op prevents all ops from applying',
      () async {
    final newKp = KeyPair.random();
    final funderAccount =
        await sdk.accounts.account(issuerKeyPair.accountId);

    // Op 1: would succeed in isolation
    final createOp =
        CreateAccountOperationBuilder(newKp.accountId, '5').build();

    // Op 2: deliberately over-balance — 50,000 XLM far exceeds FriendBot's ~10,000
    final badPayOp = PaymentOperationBuilder(
      KeyPair.random().accountId, Asset.NATIVE, '50000',
    ).build();

    final tx = TransactionBuilder(funderAccount)
        .addOperation(createOp)
        .addOperation(badPayOp)
        .build();
    tx.sign(issuerKeyPair, Network.TESTNET);

    final response = await sdk.submitTransaction(tx);
    expect(response.success, false);

    // Rollback confirmed: new account must not exist on Horizon
    await expectLater(
      sdk.accounts.account(newKp.accountId),
      throwsA(anything),
      reason: 'CreateAccountOperation must have been rolled back',
    );
  });
}
