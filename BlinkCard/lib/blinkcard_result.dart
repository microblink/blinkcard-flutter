import 'package:blinkcard_flutter/types.dart';

/// Result of scanning a card.
class BlinkCardScanningResult {
  /// Payment card's issuing network.
  final String issuingNetwork;

  /// A list of payment card accounts found on the card.
  /// Each result in the list represents a distinct payment account,
  /// containing details like the card number, CVV, and expiry date.
  ///
  /// See [CardAccountResult] for more information.
  final List<CardAccountResult> cardAccounts;

  /// The IBAN (International Bank Account Number) of the card, or null if not available.
  final String? iban;

  /// Information about the cardholder name, or null if not available.
  final String? cardholderName;

  /// The overall liveness check result for the card.
  ///
  /// This result aggregates the outcomes of various liveness checks performed on the card to determine its authenticity.
  ///
  /// Set to `pass` if all individual checks have passed;
  /// set to `fail` if any individual check has failed.
  final CheckResult overallCardLivenessResult;

  /// The result of scanning the first side of the card
  /// (side where the card number is located), or null if not scanned.
  ///
  /// See [BlinkCardSingleSideScanningResult] for more information.
  final BlinkCardSingleSideScanningResult? firstSideResult;

  /// The result of scanning the second side of the card, or null if not scanned.
  ///
  /// See [BlinkCardSingleSideScanningResult] for more information.
  final BlinkCardSingleSideScanningResult? secondSideResult;

  BlinkCardScanningResult(Map<String, dynamic> nativeBlinkCardScanningResult)
    : issuingNetwork = nativeBlinkCardScanningResult["issuingNetwork"],
      cardAccounts =
          (nativeBlinkCardScanningResult["cardAccounts"] as List<dynamic>)
              .map(
                (cardAccount) =>
                    CardAccountResult(Map<String, dynamic>.from(cardAccount)),
              )
              .toList(),

      iban = nativeBlinkCardScanningResult["iban"],
      cardholderName = nativeBlinkCardScanningResult["cardholderName"],
      overallCardLivenessResult = CheckResult.fromString(
        nativeBlinkCardScanningResult["overallCardLivenessResult"],
      ),
      firstSideResult =
          nativeBlinkCardScanningResult["firstSideResult"] != null
              ? BlinkCardSingleSideScanningResult(
                nativeBlinkCardScanningResult["firstSideResult"],
              )
              : null,

      secondSideResult =
          nativeBlinkCardScanningResult["secondSideResult"] != null
              ? BlinkCardSingleSideScanningResult(
                nativeBlinkCardScanningResult["secondSideResult"],
              )
              : null;
}
