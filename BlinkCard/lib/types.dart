import 'package:json_annotation/json_annotation.dart';
part 'types.g.dart';

/// Represents the different levels of detection sensitivity.
///
/// This enum is used to configure detection thresholds and enable or disable detection functionality.
/// The levels range from turning detection off completely to setting various levels of sensitivity (Low, Mid, High).
enum DetectionLevel {
  @JsonValue("off")
  off,
  @JsonValue("low")
  low,
  @JsonValue("mid")
  mid,
  @JsonValue("high")
  high,
}

/// Defines the strictness level used by various models to control detection sensitivity.
///
/// Higher levels apply stricter validation criteria, improving security and reducing false accepts (FAR), but may increase false rejects (FRR).
///
/// Levels are ordered by increasing strictness:
///
/// 1. Disabled turns the check off.
/// 2. The first active level has the lowest FRR and highest FAR.
/// 3. The last level has the highest FRR and lowest FAR.
enum StrictnessLevel {
  @JsonValue("disabled")
  disabled,
  @JsonValue("level1")
  level1,
  @JsonValue("level2")
  level2,
  @JsonValue("level3")
  level3,
  @JsonValue("level4")
  level4,
  @JsonValue("level5")
  level5,
  @JsonValue("level6")
  level6,
  @JsonValue("level7")
  level7,
  @JsonValue("level8")
  level8,
  @JsonValue("level9")
  level9,
  @JsonValue("level10")
  level10,
}

/// Result of a single check performed during the document verification process.
enum CheckResult {
  @JsonValue("notPerformed")
  notPerformed,
  @JsonValue("pass")
  pass,
  @JsonValue("fail")
  fail;

  static CheckResult fromString(String s) => switch (s) {
    "notPerformed" => notPerformed,
    "pass" => pass,
    "fail" => fail,
    _ => notPerformed,
  };
}

/// Represents level of anonymization performed on the scanning result.
enum AnonymizationMode {
  /// Anonymization will not be performed.
  @JsonValue("none")
  none,

  /// Full document image is anonymized with black boxes covering sensitive data.
  @JsonValue("imageOnly")
  imageOnly,

  /// Result fields containing sensitive data are removed from result.
  @JsonValue("resultFieldsOnly")
  resultFieldsOnly,

  /// This mode is combination of ImageOnly and ResultFieldsOnly modes.
  @JsonValue("fullResult")
  fullResult,
}

/// Represents camera positions used for card information extraction.
enum CameraPosition {
  /// Front-facing camera
  @JsonValue("front")
  front,

  /// Back-facing camera
  @JsonValue("back")
  back,
}

/// Holds the settings which control card number anonymization.
@JsonSerializable()
final class CardNumberAnonymizationSettings {
  /// Defines the mode of card number anonymization.
  ///
  /// Default: [AnonymizationMode.none]
  AnonymizationMode anonymizationMode;

  /// Defines how many digits at the beginning
  /// of the card number remain visible after anonymization.
  ///
  /// Default: `0`
  int prefixDigitsVisible;

  /// Defines how many digits at the end
  /// of the card number remain visible after anonymization.
  ///
  /// Default: `0`
  int suffixDigitsVisible;

  /// Holds the settings which control card number anonymization.
  CardNumberAnonymizationSettings({
    this.anonymizationMode = AnonymizationMode.none,
    this.prefixDigitsVisible = 0,
    this.suffixDigitsVisible = 0,
  });

  factory CardNumberAnonymizationSettings.fromJson(Map<String, dynamic> json) =>
      _$CardNumberAnonymizationSettingsFromJson(json);
  Map<String, dynamic> toJson() =>
      _$CardNumberAnonymizationSettingsToJson(this);
}

/// Represents the account information of a single account on a card.
final class CardAccountResult {
  /// The card number as scanned from the card.
  final String cardNumber;

  /// Indicates whether the scanned card number is valid according to the Luhn algorithm.
  final bool cardNumberValid;

  /// The payment card's number prefix.
  final String? cardNumberPrefix;

  /// The payment card's security code/value.
  final String? cvv;

  /// The payment card's expiry date.
  final DateResult<String>? expiryDate;

  /// The card funding type (e.g., "DEBIT", "CREDIT", "CHARGE CARD").
  final String? fundingType;

  /// The category of the payment card
  /// (e.g., "PERSONAL", "BUSINESS", "PREPAID").
  ///
  /// This information typically indicates the card's tier or service level.
  final String? cardCategory;

  /// The name of the financial institution that issued the payment card.
  final String? issuerName;

  /// The ISO 3166-1 alpha-3 country code of the card issuer's country (e.g., "USA", "GBR", "HRV").
  final String? issuerCountryCode;

  /// The name of the card issuer's country.
  final String? issuerCountry;

  CardAccountResult(Map<String, dynamic> nativeCardAccountResult)
    : cardNumber = nativeCardAccountResult["cardNumber"],
      cardNumberValid = nativeCardAccountResult["cardNumberValid"],
      cardNumberPrefix = nativeCardAccountResult["cardNumberPrefix"],
      cvv = nativeCardAccountResult["cvv"],
      expiryDate =
          nativeCardAccountResult["expiryDate"] != null
              ? DateResult(nativeCardAccountResult["expiryDate"])
              : null,
      fundingType = nativeCardAccountResult["fundingType"],
      cardCategory = nativeCardAccountResult["cardCategory"],
      issuerName = nativeCardAccountResult["issuerName"],
      issuerCountryCode = nativeCardAccountResult["issuerCountryCode"],
      issuerCountry = nativeCardAccountResult["issuerCountry"];
}

/// Represents the result of the date extraction.
final class DateResult<StringType> {
  /// Day of the month.
  ///
  /// The first day of the month has value `1`
  final int? day;

  /// Month of the year.
  ///
  /// The first month of the year has value `1`
  final int? month;

  /// Full year.
  final int? year;

  /// Original string representation of the date which has been extracted.
  final StringType originalString;

  /// Indicates that date does not appear on the document
  /// but is filled by our internal domain knowledge.
  final bool filledByDomainKnowledge;

  /// Indicates whether date was successfully parsed.
  final bool successfullyParsed;

  DateResult(Map<String, dynamic> nativeDateResult)
    : day = nativeDateResult["day"],
      month = nativeDateResult["month"],
      year = nativeDateResult["year"],
      originalString = nativeDateResult["originalString"],
      filledByDomainKnowledge =
          nativeDateResult["filledByDomainKnowledge"] ?? false,
      successfullyParsed = nativeDateResult["successfullyParsed"] ?? true;
}

/// Represents the result of scanning a single side of the card.
///
/// Contains the cropped card image and liveness check results
/// from scanning one side of a card.
final class BlinkCardSingleSideScanningResult {
  /// The cropped image of the scanned card, or null if image capture failed.
  final CroppedImageResult? cardImage;

  /// The result of the card liveness verification check.
  final CardLivenessCheckResult cardLivenessCheckResult;

  BlinkCardSingleSideScanningResult(
    Map<String, dynamic> nativeBlinkCardSingleSideScanningResult,
  ) : cardImage =
          nativeBlinkCardSingleSideScanningResult["cardImage"] != null
              ? CroppedImageResult(
                nativeBlinkCardSingleSideScanningResult["cardImage"],
              )
              : null,
      cardLivenessCheckResult = CardLivenessCheckResult.fromMap(
        nativeBlinkCardSingleSideScanningResult["cardLivenessCheckResult"],
      );
}

final class CroppedImageResult {
  final String? image;

  CroppedImageResult(Map<String, dynamic> nativeCroppedImageResult)
    : image = nativeCroppedImageResult["image"];
}

/// Structure representing the result of liveness checks for a card.
final class CardLivenessCheckResult {
  /// Result of the liveness check that detects whether the card is displayed on a screen.
  final CheckResult screenCheckResult;

  /// Result of the liveness check that detects whether the input image is a photocopy of a card.
  final CheckResult photocopyCheckResult;

  /// Result of the liveness check that detects whether a card is being held in human hands.
  final CheckResult cardHeldInHandCheckResult;

  CardLivenessCheckResult.fromMap(
    Map<String, dynamic> nativeCardLivenessCheckResult,
  ) : screenCheckResult = CheckResult.fromString(
        nativeCardLivenessCheckResult['screenCheckResult'],
      ),
      photocopyCheckResult = CheckResult.fromString(
        nativeCardLivenessCheckResult['photocopyCheckResult'],
      ),
      cardHeldInHandCheckResult = CheckResult.fromString(
        nativeCardLivenessCheckResult['cardHeldInHandCheckResult'],
      );
}
