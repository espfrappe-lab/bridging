// Tests generated from documentation/sdk-usage.md § "Creating Keypairs" (subtopic 1.1).
// Pipeline: US-01..03 → AC-01..03 → SC-01..03 → TS-01..03

import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

// -- Test data ----------------------------------------------------------
// AMB-4: The documentation's example seed (SCZANGBA5Y...) fails strkey
// checksum validation and cannot be used as test input. It is a non-valid
// placeholder. A verified seed/accountId pair from the SDK's own unit tests
// is used for all fromSecretSeed tests.
const String _knownSeed =
    'SDJHRQF4GCMIIKAAAQ6IHY42X73FQFLHUULAPSKKD4DFDM7UXWWCRHBE';
const String _knownAccountId =
    'GCZHXL5HXQX5ABDM26LHYRCQZ5OJFHLOPLZX47WEBP3V2PF5AVFK2A5D';

// Second valid seed (round-trip test only, no expected accountId needed).
const String _roundTripSeed =
    'SAB5556L5AN5KSR5WF7UOEFDCIODEWEO7H2UR4S5R62DFTQOGLKOVZDY';

// A valid account ID for public-key-only tests.
const String _validAccountId =
    'GBBM6BKZPEHWYO3E3YKREDPQXMS4VK35YLNU7NFBRI26RAN7GI5POFBB';

void main() {
  // -----------------------------------------------------------------------
  // US-01: Generate a random Stellar keypair
  // -----------------------------------------------------------------------
  group('US-01: KeyPair.random()', () {
    test('TS-01.1 — returns a non-null KeyPair', () {
      // AC-01.1
      final kp = KeyPair.random();
      expect(kp, isNotNull);
    });

    test('TS-01.2 — accountId is non-empty and starts with G', () {
      // AC-01.2
      final kp = KeyPair.random();
      expect(kp.accountId, isNotEmpty);
      expect(kp.accountId.startsWith('G'), isTrue);
    });

    test('TS-01.3 — secretSeed is non-empty and starts with S', () {
      // AC-01.3
      final kp = KeyPair.random();
      expect(kp.secretSeed, isNotEmpty);
      expect(kp.secretSeed.startsWith('S'), isTrue);
    });

    test('TS-01.4 — successive calls produce unique keypairs', () {
      // AC-01.4
      final kp1 = KeyPair.random();
      final kp2 = KeyPair.random();
      expect(kp1.accountId, isNot(equals(kp2.accountId)));
      expect(kp1.secretSeed, isNot(equals(kp2.secretSeed)));
    });

    test('TS-01.5 — generated keypair can sign', () {
      // AC-01.5
      final kp = KeyPair.random();
      expect(kp.canSign(), isTrue);
    });
  });

  // -----------------------------------------------------------------------
  // US-02: Create a keypair from an existing secret seed
  // -----------------------------------------------------------------------
  group('US-02: KeyPair.fromSecretSeed()', () {
    test('TS-02.1 — valid seed returns a non-null KeyPair', () {
      // AC-02.1 (AMB-4: doc example seed is invalid; using verified seed)
      final kp = KeyPair.fromSecretSeed(_knownSeed);
      expect(kp, isNotNull);
    });

    test('TS-02.2 — secretSeed round-trips to the original input', () {
      // AC-02.2
      final kp = KeyPair.fromSecretSeed(_roundTripSeed);
      expect(kp.secretSeed, equals(_roundTripSeed));
    });

    test('TS-02.3 — same seed always produces the same accountId (determinism)', () {
      // AC-02.3 — uses the known seed/accountId pair (see AMB-3)
      final kp1 = KeyPair.fromSecretSeed(_knownSeed);
      final kp2 = KeyPair.fromSecretSeed(_knownSeed);
      expect(kp1.accountId, equals(_knownAccountId));
      expect(kp2.accountId, equals(kp1.accountId));
    });

    test('TS-02.4 — keypair from seed can sign', () {
      // AC-02.4
      final kp = KeyPair.fromSecretSeed(_knownSeed);
      expect(kp.canSign(), isTrue);
    });

    test('TS-02.5a — malformed string throws FormatException', () {
      // AC-02.5 — arbitrary non-strkey string
      expect(
        () => KeyPair.fromSecretSeed('INVALID_SEED'),
        throwsA(isA<FormatException>()),
      );
    });

    test('TS-02.5b — account ID passed as seed throws FormatException', () {
      // AC-02.5 — G… address passed where S… is required
      expect(
        () => KeyPair.fromSecretSeed(_validAccountId),
        throwsA(isA<FormatException>()),
      );
    });

    test('TS-02.5c — doc example seed (invalid checksum) throws FormatException', () {
      // AMB-4: The documentation shows SCZANGBA5Y... as an example seed,
      // but it has an invalid strkey checksum. This test documents that
      // the SDK correctly rejects it rather than silently accepting bad data.
      expect(
        () => KeyPair.fromSecretSeed(
            'SCZANGBA5YHTNYVVV3C7CAZMTQDBJHJG6C34JFD6XVEAEPTBED53FETV'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // -----------------------------------------------------------------------
  // US-03: Create a public-key-only keypair from an account ID
  // -----------------------------------------------------------------------
  group('US-03: KeyPair.fromAccountId()', () {
    test('TS-03.1 — valid account ID returns a non-null KeyPair', () {
      // AC-03.1
      final kp = KeyPair.fromAccountId(_validAccountId);
      expect(kp, isNotNull);
    });

    test('TS-03.2 — accountId property equals the input string', () {
      // AC-03.2
      final kp = KeyPair.fromAccountId(_validAccountId);
      expect(kp.accountId, equals(_validAccountId));
    });

    test('TS-03.3 — public-key-only keypair cannot sign', () {
      // AC-03.3
      final kp = KeyPair.fromAccountId(_validAccountId);
      expect(kp.canSign(), isFalse);
    });

    test('TS-03.4a — malformed string throws FormatException', () {
      // AC-03.4 — arbitrary non-strkey string
      expect(
        () => KeyPair.fromAccountId('INVALID_ACCOUNT_ID'),
        throwsA(isA<FormatException>()),
      );
    });

    test('TS-03.4b — secret seed passed as account ID throws FormatException', () {
      // AC-03.4 — S… seed passed where G… account ID is required
      expect(
        () => KeyPair.fromAccountId(_knownSeed),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
