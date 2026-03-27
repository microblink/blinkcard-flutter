import 'package:blinkcard_flutter/blinkcard_flutter.dart';

class BlinkCardResultBuilder {
  static String getCardResultString(BlinkCardScanningResult? result) {
    if (result == null) {
      return "";
    }

    String resultString =
        buildStringResult(result.cardholderName, "Cardholder name") +
        buildStringResult(result.iban, "IBAN") +
        buildStringResult(result.issuingNetwork, "Issuing network") +
        buildStringResult(
          result.overallCardLivenessResult.name.toUpperCase(),
          "Overall card liveness result",
        ) +
        buildCardAccounts(result.cardAccounts) +
        buildSingleSideScanningResult(
          result.firstSideResult,
          "First side result",
        ) +
        buildSingleSideScanningResult(result.secondSideResult, "Second side");

    return "$resultString\n";
  }

  static String buildCardAccounts(List<CardAccountResult>? cardAccounts) {
    String cardAccountString = "";

    if (cardAccounts != null) {
      for (var singleSideResult in cardAccounts.asMap().entries) {
        final index = singleSideResult.key;
        final result = singleSideResult.value;

        cardAccountString += "\nCard account ${index + 1} information:\n";
        cardAccountString += buildStringResult(
          result.cardCategory,
          "Card category",
        );
        cardAccountString += buildStringResult(
          result.cardNumber,
          "Card number",
        );
        cardAccountString += buildStringResult(
          result.cardNumberValid ? "YES" : "NO",
          "Card number valid",
        );
        cardAccountString += buildStringResult(
          result.cardNumberPrefix,
          "Card number prefix",
        );
        cardAccountString += buildStringResult(
          "${result.expiryDate?.month}/${result.expiryDate?.year}",
          "Expiry date",
        );
        cardAccountString += buildStringResult(result.cvv, "CVV");
        cardAccountString += buildStringResult(
          result.issuerName,
          "Issuer name",
        );
        cardAccountString += buildStringResult(
          result.issuerCountryCode,
          "Issuer country code",
        );
        cardAccountString += buildStringResult(
          result.issuerCountry,
          "Issuer country",
        );
      }
    }
    return cardAccountString;
  }

  static String buildSingleSideScanningResult(
    BlinkCardSingleSideScanningResult? result,
    String name,
  ) {
    if (result == null) return "";

    final singleSideResultString =
        "Liveness check result:\n${buildCardLivenessCheckResult(result.cardLivenessCheckResult)}";

    return "\n$name:\n$singleSideResultString";
  }

  static String buildCardLivenessCheckResult(CardLivenessCheckResult? result) {
    if (result == null) return "";
    final livenessCheckResultString =
        buildStringResult(
          result.cardHeldInHandCheckResult.name.toUpperCase(),
          "Card held in hand check result",
        ) +
        buildStringResult(
          result.photocopyCheckResult.name.toUpperCase(),
          "Photocopy check result",
        ) +
        buildStringResult(
          result.screenCheckResult.name.toUpperCase(),
          "Screen check result",
        );

    return livenessCheckResultString;
  }

  static String buildStringResult(String? result, String propertyName) {
    if (result == null || result.isEmpty) {
      return "";
    }

    return "$propertyName: $result\n";
  }

  static String buildIntResult(int? result, String propertyName) {
    if (result == null || result < 0) {
      return "";
    }

    return "$propertyName: $result\n";
  }
}
