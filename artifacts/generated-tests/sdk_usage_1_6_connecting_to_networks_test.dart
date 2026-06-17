// Tests generated from documentation/sdk-usage.md § "Connecting to Networks" (subtopic 1.6).
// Pipeline: US-01..04 → AC-01.1..AC-05.1 → SC-01.1..SC-05.1 → TS-01.1..TS-05.1
//
// AMB-1: Invalid/non-HTTPS URLs not documented. Only the valid URL path is tested.
// TL-1:  "Network passphrase is used when signing transactions" — signing is a
//         separate operation; this suite only verifies constant availability and
//         mutual distinctness of the three Network objects.
//
// All operations are synchronous and local — no network I/O.

@Timeout(const Duration(seconds: 10))

import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

void main() {
  // -----------------------------------------------------------------------
  // US-01: Testnet — StellarSDK instance + Network passphrase
  // -----------------------------------------------------------------------
  group('US-01: Testnet', () {
    test('TS-01.1 — StellarSDK.TESTNET returns a non-null instance', () {
      // AC-01.1 / SC-01.1
      expect(StellarSDK.TESTNET, isNotNull);
    });

    test('TS-01.2 — Network.TESTNET returns a non-null Network object', () {
      // AC-01.2 / SC-01.2
      expect(Network.TESTNET, isNotNull);
    });
  });

  // -----------------------------------------------------------------------
  // US-02: Public (production) network
  // -----------------------------------------------------------------------
  group('US-02: Public network', () {
    test('TS-02.1 — StellarSDK.PUBLIC returns a non-null instance', () {
      // AC-02.1 / SC-02.1
      expect(StellarSDK.PUBLIC, isNotNull);
    });

    test('TS-02.2 — Network.PUBLIC returns a non-null Network object', () {
      // AC-02.2 / SC-02.2
      expect(Network.PUBLIC, isNotNull);
    });
  });

  // -----------------------------------------------------------------------
  // US-03: Futurenet
  // -----------------------------------------------------------------------
  group('US-03: Futurenet', () {
    test('TS-03.1 — StellarSDK.FUTURENET returns a non-null instance', () {
      // AC-03.1 / SC-03.1
      expect(StellarSDK.FUTURENET, isNotNull);
    });

    test('TS-03.2 — Network.FUTURENET returns a non-null Network object', () {
      // AC-03.2 / SC-03.2
      expect(Network.FUTURENET, isNotNull);
    });
  });

  // -----------------------------------------------------------------------
  // US-04: Custom Horizon server
  // -----------------------------------------------------------------------
  group('US-04: Custom Horizon server', () {
    test('TS-04.1 — StellarSDK constructor accepts a custom HTTPS URL', () {
      // AC-04.1 / SC-04.1
      // Docs: StellarSDK sdk = StellarSDK("https://my-horizon-server.example.com");
      final sdk = StellarSDK('https://my-horizon-server.example.com');
      expect(sdk, isNotNull);
    });
  });

  // -----------------------------------------------------------------------
  // Cross-cutting invariant: each network has its own passphrase (AC-05.1)
  // -----------------------------------------------------------------------
  group('Invariant: Network constants are mutually distinct', () {
    test('TS-05.1 — TESTNET, PUBLIC, and FUTURENET Network objects are all different', () {
      // AC-05.1 / SC-05.1
      // Docs: "each with its own Horizon server and network passphrase"
      expect(Network.TESTNET, isNot(equals(Network.PUBLIC)));
      expect(Network.TESTNET, isNot(equals(Network.FUTURENET)));
      expect(Network.PUBLIC,  isNot(equals(Network.FUTURENET)));
    });
  });
}
